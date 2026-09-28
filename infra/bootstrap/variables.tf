variable "region" {
  description = "Região AWS (us-east-1 é obrigatória para o certificado ACM usado pelo CloudFront)."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domínio do site; também usado para nomear recursos."
  type        = string
}

variable "github_owner" {
  description = "Usuário ou organização dona do repositório no GitHub."
  type        = string
}

variable "github_repo" {
  description = "Nome do repositório no GitHub."
  type        = string
}

variable "alert_email" {
  description = "E-mail dos alertas do AWS Budgets (vira a variável ALERT_EMAIL no GitHub; não fica no repositório)."
  type        = string
}
