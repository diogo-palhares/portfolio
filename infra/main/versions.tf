terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # The bucket is passed at init time:
  #   terraform init -backend-config="bucket=<bootstrap state_bucket output>"
  backend "s3" {
    key          = "portfolio/main.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  # CloudFront only accepts ACM certificates issued in us-east-1
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "portfolio"
      Stack     = "main"
      ManagedBy = "terraform"
    }
  }
}
