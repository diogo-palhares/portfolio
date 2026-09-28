# Parâmetros lidos pelo job de deploy: o pipeline não depende de variáveis
# preenchidas à mão depois do apply.
resource "aws_ssm_parameter" "site_bucket" {
  name  = "/portfolio/site-bucket"
  type  = "String"
  value = aws_s3_bucket.site.bucket
}

resource "aws_ssm_parameter" "distribution_id" {
  name  = "/portfolio/cloudfront-distribution-id"
  type  = "String"
  value = aws_cloudfront_distribution.site.id
}
