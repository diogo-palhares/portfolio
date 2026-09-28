variable "domain_name" {
  description = "Domínio apex do site (registrado no Route 53)."
  type        = string
}

variable "alert_email" {
  description = "E-mail que recebe os alertas do AWS Budgets."
  type        = string
}

variable "monthly_budget_usd" {
  description = "Limite mensal de custo da conta, em USD, para disparar alertas."
  type        = number
  default     = 5
}

variable "price_class" {
  description = "Price class do CloudFront. PriceClass_All inclui edges na América do Sul."
  type        = string
  default     = "PriceClass_All"
}
