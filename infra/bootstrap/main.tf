# Bootstrap: recursos que precisam existir ANTES do pipeline.
# Roda uma única vez, localmente, com credenciais de administrador.
#   - Bucket S3 do state remoto do Terraform (lock nativo via use_lockfile)
#   - Provedor OIDC do GitHub Actions
#   - Role "infra" (terraform plan/apply) e role "deploy" (s3 sync + invalidação)
#   - Variáveis do repositório no GitHub usadas pelo pipeline
#
# Autenticação no GitHub: usa o token do `gh auth login` (ou GITHUB_TOKEN).

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # Depois do primeiro apply, é possível migrar este state para o próprio bucket:
  # descomente o bloco abaixo e rode `terraform init -migrate-state`.
  # backend "s3" {
  #   bucket       = "<saida state_bucket>"
  #   key          = "portfolio/bootstrap.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "portfolio"
      Stack     = "bootstrap"
      ManagedBy = "terraform"
    }
  }
}

provider "github" {
  owner = var.github_owner
}

data "aws_caller_identity" "current" {}

# IDs numéricos do dono e do repositório: o GitHub emite o "sub" do token OIDC
# no formato imutável repo:<dono>@<id>/<repo>@<id>:..., que não pode ser
# reaproveitado por outro repositório criado com o mesmo nome.
data "github_user" "owner" {
  username = var.github_owner
}

data "github_repository" "this" {
  full_name = "${var.github_owner}/${var.github_repo}"
}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  name         = replace(var.domain_name, ".", "-")
  repo         = "${var.github_owner}@${data.github_user.owner.id}/${var.github_repo}@${data.github_repository.this.repo_id}"
  state_bucket = "${local.name}-tfstate-${local.account_id}"
  # Mesmos padrões usados em infra/main
  site_bucket = "${local.name}-site-${local.account_id}"
  ssm_prefix  = "arn:aws:ssm:${var.region}:${local.account_id}:parameter/portfolio"
}

# ---------------------------------------------------------------------------
# State remoto
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "tfstate" {
  bucket = local.state_bucket

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    id     = "expire-old-state-versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# ---------------------------------------------------------------------------
# OIDC GitHub Actions -> AWS (sem access keys guardadas no GitHub)
# ---------------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "infra_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # PRs rodam plan; a branch main roda apply
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${local.repo}:ref:refs/heads/main",
        "repo:${local.repo}:pull_request",
      ]
    }
  }
}

data "aws_iam_policy_document" "deploy_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Só a main publica o site
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.repo}:ref:refs/heads/main"]
    }
  }
}

# ---------------------------------------------------------------------------
# Role infra: gerencia S3 do site, CloudFront, ACM, Route 53 e Budgets
# ---------------------------------------------------------------------------
resource "aws_iam_role" "infra" {
  name                 = "${local.name}-github-infra"
  assume_role_policy   = data.aws_iam_policy_document.infra_trust.json
  max_session_duration = 3600
}

data "aws_iam_policy_document" "infra" {
  statement {
    sid       = "StateBucketList"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.tfstate.arn]
  }

  statement {
    sid       = "StateObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.tfstate.arn}/*"]
  }

  statement {
    sid     = "SiteBucket"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${local.site_bucket}",
      "arn:aws:s3:::${local.site_bucket}/*",
    ]
  }

  statement {
    sid       = "PipelineParameters"
    actions   = ["ssm:*"]
    resources = ["${local.ssm_prefix}/*"]
  }

  statement {
    sid       = "DescribeParameters"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    sid = "EdgeDnsCertBudget"
    actions = [
      "cloudfront:*",
      "acm:*",
      "route53:*",
      "budgets:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "infra" {
  name   = "terraform-portfolio"
  role   = aws_iam_role.infra.id
  policy = data.aws_iam_policy_document.infra.json
}

# ---------------------------------------------------------------------------
# Role deploy: apenas sincroniza arquivos e invalida o cache
# ---------------------------------------------------------------------------
resource "aws_iam_role" "deploy" {
  name                 = "${local.name}-github-deploy"
  assume_role_policy   = data.aws_iam_policy_document.deploy_trust.json
  max_session_duration = 3600
}

data "aws_iam_policy_document" "deploy" {
  statement {
    sid       = "ReadPipelineParameters"
    actions   = ["ssm:GetParameter", "ssm:GetParameters"]
    resources = ["${local.ssm_prefix}/*"]
  }

  statement {
    sid       = "ListSiteBucket"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.site_bucket}"]
  }

  statement {
    sid       = "WriteSiteObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${local.site_bucket}/*"]
  }

  statement {
    sid       = "InvalidateCache"
    actions   = ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation"]
    resources = ["arn:aws:cloudfront::${local.account_id}:distribution/*"]
  }
}

resource "aws_iam_role_policy" "deploy" {
  name   = "deploy-portfolio"
  role   = aws_iam_role.deploy.id
  policy = data.aws_iam_policy_document.deploy.json
}

# ---------------------------------------------------------------------------
# Variáveis do repositório consumidas por .github/workflows/pipeline.yml
# ---------------------------------------------------------------------------
locals {
  github_variables = {
    TF_STATE_BUCKET     = aws_s3_bucket.tfstate.bucket
    AWS_INFRA_ROLE_ARN  = aws_iam_role.infra.arn
    AWS_DEPLOY_ROLE_ARN = aws_iam_role.deploy.arn
    ALERT_EMAIL         = var.alert_email
  }
}

resource "github_actions_variable" "pipeline" {
  for_each = local.github_variables

  repository    = var.github_repo
  variable_name = each.key
  value         = each.value
}
