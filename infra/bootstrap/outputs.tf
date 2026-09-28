output "state_bucket" {
  description = "Remote state bucket (also stored as TF_STATE_BUCKET in GitHub)."
  value       = aws_s3_bucket.tfstate.bucket
}

output "infra_role_arn" {
  value = aws_iam_role.infra.arn
}

output "deploy_role_arn" {
  value = aws_iam_role.deploy.arn
}

output "github_variables" {
  description = "Variables created in the repository."
  value       = sort(keys(github_actions_variable.pipeline))
}
