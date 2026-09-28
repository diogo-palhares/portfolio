terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # O bucket é informado no init:
  #   terraform init -backend-config="bucket=<saida state_bucket do bootstrap>"
  backend "s3" {
    key          = "portfolio/main.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  # CloudFront só aceita certificados ACM emitidos em us-east-1
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "portfolio"
      Stack     = "main"
      ManagedBy = "terraform"
    }
  }
}
