resource "aws_route53_record" "www" {
    zone_id = "Z071318222CSF3HADRP6W"
    name = "www.<your_domain_name>"
    type = "A"
    alias {
        name = aws_cloudfront_distribution.no-www.domain_name #change to cloudfront once set up
        zone_id = aws_cloudfront_distribution.no-www.hosted_zone_id
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "no-www" {
    zone_id = "Z071318222CSF3HADRP6W" # can be changed to non static if zone is done through terraform
    name = "<your_domain_name>"
    type = "A"
    alias { 
        name = aws_cloudfront_distribution.www.domain_name #change to cloudfront once set up
        zone_id = aws_cloudfront_distribution.www.hosted_zone_id
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "DNS" {
  for_each = {
    for dvo in aws_acm_certificate.cert_main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z071318222CSF3HADRP6W" # can be changed to non static if zone is done through terraform
}



