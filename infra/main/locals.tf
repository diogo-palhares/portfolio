data "aws_caller_identity" "current" {}

# The hosted zone is created automatically when the domain is registered in Route 53
data "aws_route53_zone" "site" {
  name         = var.domain_name
  private_zone = false
}

locals {
  name        = replace(var.domain_name, ".", "-")
  site_bucket = "${local.name}-site-${data.aws_caller_identity.current.account_id}"
  hostnames   = [var.domain_name, "www.${var.domain_name}"]

  alias_records = {
    for pair in setproduct(local.hostnames, ["A", "AAAA"]) :
    "${pair[0]}-${pair[1]}" => { name = pair[0], type = pair[1] }
  }
}
