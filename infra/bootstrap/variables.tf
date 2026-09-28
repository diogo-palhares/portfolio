variable "region" {
  description = "AWS region (us-east-1 is required for the ACM certificate used by CloudFront)."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Site domain; also used to name resources."
  type        = string
}

variable "github_owner" {
  description = "GitHub user or organization that owns the repository."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
}

variable "alert_email" {
  description = "Email for AWS Budgets alerts (stored as the ALERT_EMAIL GitHub variable, never committed)."
  type        = string
}
