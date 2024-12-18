
resource "aws_s3_bucket" "redirect" {
  bucket = "www.<your_domain_name>"
}

resource "aws_s3_bucket_public_access_block" "redirect_access_block" {
  bucket = aws_s3_bucket.redirect.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "redirect_web" {
  bucket = aws_s3_bucket.redirect.id
  redirect_all_requests_to {
    host_name = "<your_domain_name>"
    protocol = "https"
  }
}

