# Parameters read by the deploy job, so the pipeline never depends on values
# copied by hand after an apply.
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
