# portfolio · diogopalhares.com

Personal website (resume, projects and technical notes): a static site on AWS, with all infrastructure in Terraform and deployments via GitHub Actions over OIDC.

## Architecture

```
Visitor ──HTTPS──▶ Route 53 ──▶ CloudFront (CDN + TLS/ACM + CloudFront Function + security headers)
                                    │  Origin Access Control
                                    ▼
                              S3 (private bucket)

GitHub ──▶ GitHub Actions ──OIDC──▶ IAM roles (infra / deploy)
            pipeline.yml:
            changes ─┬─ infra-lint ─┬─ infra-plan   (PR: plan posted as a comment)
                     │              └─ infra-apply  (main) ─┐
                     └─ site-build ─────────────────────────┴─ site-deploy (main)
```

| Path | Contents |
|---|---|
| `site/` | [Astro](https://astro.build) site. Content guide in [`site/CONTENT.md`](site/CONTENT.md) |
| `infra/bootstrap/` | Applied **once**, locally: state bucket, OIDC provider, `infra`/`deploy` roles and GitHub repository variables |
| `infra/main/` | S3, CloudFront, ACM, Route 53, CloudFront Function, security headers, AWS Budget and pipeline SSM parameters |
| `.github/workflows/pipeline.yml` | Single pipeline: detects what changed, applies infra, then publishes the site |

### How the pipeline is chained

- The `changes` job diffs the commit against its base and decides whether to run infra, site or both. Manual runs and the first push run everything.
- `site-deploy` depends on `infra-apply`: it runs after a successful apply, or right away when infra did not change.
- The deploy job reads the bucket name and distribution ID from **SSM Parameter Store** (`/portfolio/*`), written by Terraform. Nothing has to be copied by hand after an apply.
- The `deploy` role can only read those parameters, write to the site bucket and invalidate the cache. The `infra` role only trusts tokens from `main` and pull requests of this repository, pinned to its immutable OIDC subject (owner and repository numeric IDs).

## Estimated cost

| Item | Cost |
|---|---|
| `.com` domain (Route 53) | ~US$15/year |
| Route 53 hosted zone | US$0.50/month |
| S3 + CloudFront + ACM + SSM (standard) | ~US$0 (portfolio traffic stays within the free tier) |

AWS Budget alerts at 80% (actual) and 100% (forecasted) of US$5/month.

## Prerequisites

- Node.js 22.12+ (recommended: 24 LTS)
- Terraform 1.10+
- AWS CLI v2 authenticated with administrator permissions
- GitHub CLI (`gh auth login`)
- Domain registered in Route 53 (the hosted zone is created automatically)

## First-time setup

### 1. Bootstrap (the only manual step)
Creates the state bucket, OIDC provider, roles and the `TF_STATE_BUCKET`, `AWS_INFRA_ROLE_ARN`, `AWS_DEPLOY_ROLE_ARN` and `ALERT_EMAIL` repository variables.

PowerShell:
```powershell
$env:GITHUB_TOKEN = gh auth token
terraform -chdir=infra/bootstrap init
terraform -chdir=infra/bootstrap apply   # prompts for alert_email
```

### 2. Push
```bash
git push -u origin main
```
The pipeline creates the main infrastructure (5-15 min on the first apply) and publishes the site.

## Workflow

- **Infra:** branch → PR (lint, scan and `plan` comment) → merge (`apply` and, if the site changed, deploy).
- **Content:** change under `site/` → PR (validation build) → merge (deploy + invalidation).
- **Manual:** *Actions → pipeline → Run workflow* runs everything.

## Running the main stack locally (optional)
```bash
terraform -chdir=infra/main init -backend-config="bucket=$(terraform -chdir=infra/bootstrap output -raw state_bucket)"
terraform -chdir=infra/main plan -var="alert_email=<your email>"
```

## Accepted checkov findings

checkov runs in informational mode (`soft_fail`). Some findings are accepted given the cost and scope of a personal static site: WAF, S3/CloudFront access logs, cross-region replication, customer-managed KMS encryption, SSM SecureString for non-secret values, and origin failover. They can be enabled later if needed.
