variable "domain_name" {
  description = "Apex domain of the site (registered in Route 53)."
  type        = string
}

variable "alert_email" {
  description = "Email that receives AWS Budgets alerts."
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly account cost limit, in USD, that triggers alerts."
  type        = number
  default     = 5
}

variable "price_class" {
  description = "CloudFront price class. PriceClass_All includes South American edge locations."
  type        = string
  default     = "PriceClass_All"
}
