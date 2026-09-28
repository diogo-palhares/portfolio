output "state_bucket" {
  description = "Bucket do state remoto (também gravado em TF_STATE_BUCKET no GitHub)."
  value       = aws_s3_bucket.tfstate.bucket
}

output "infra_role_arn" {
  value = aws_iam_role.infra.arn
}

output "deploy_role_arn" {
  value = aws_iam_role.deploy.arn
}

output "github_variables" {
  description = "Variáveis criadas no repositório."
  value       = sort(keys(github_actions_variable.pipeline))
}
