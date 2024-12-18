resource "aws_cloudfront_distribution" "no-www" {
    origin {
        custom_origin_config {
          http_port = "80"
          https_port = "443"
          origin_protocol_policy = "http-only"
          origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
        }
        domain_name = aws_s3_bucket_website_configuration.main_web.website_endpoint
        origin_id = "s3-main-id"
    }
    
    aliases = ["<your_domain_name>"]

    default_cache_behavior {
        target_origin_id = "s3-main-id"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    }
    enabled = true
    restrictions {
        geo_restriction {
          restriction_type = "none"
        }
    }
    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate.cert_main.arn
        ssl_support_method = "sni-only"
    } 
}

resource "aws_cloudfront_distribution" "www" {
    origin {
        custom_origin_config {
          http_port = "80"
          https_port = "443"
          origin_protocol_policy = "http-only"
          origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
        }
        domain_name = aws_s3_bucket_website_configuration.redirect_web.website_endpoint
        origin_id = "s3-redirect-id"
    }
    
    aliases = ["www.<your_domain_name>"]

    default_cache_behavior {
        target_origin_id = "s3-redirect-id"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    }
    enabled = true
    restrictions {
        geo_restriction {
          restriction_type = "none"
        }
    }
    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate.cert_main.arn
        ssl_support_method = "sni-only"
    } 
}


