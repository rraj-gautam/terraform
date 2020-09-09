# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "~> v2.0"

#   domain_name  = "jenkins.sysdaemons.com"
#   zone_id      = "Z2ES7B9AZ6SHAE"

#   subject_alternative_names = [
#     "*.my-domain.com",
#     "app.sub.my-domain.com",
#   ]

#   tags = {
#     Name = "my-domain.com"
#   }
# }

resource "aws_acm_certificate" "cert" {
  domain_name       = "jenkins.sysdaemons.com"
  validation_method = "DNS"

  tags = {
    Environment = "test"
    Name = "jenkins.sysdaemons.com"
  }

  lifecycle {
    create_before_destroy = true
  }
}