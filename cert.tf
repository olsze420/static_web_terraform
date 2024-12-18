
resource "aws_acm_certificate" "cert_main" {
  provider = aws.us
    domain_name = "<your_domain_name>"
    subject_alternative_names = ["www.<your_domain_name"]
    validation_method = "DNS"
}
