resource "aws_s3_bucket" "redirect_static_bucket" {
    bucket = "michalolszewski.click"
}

resource "aws_s3_bucket_public_access_block" "disable_public_block_redirect" {
    bucket = aws_s3_bucket.redirect_static_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_web_redirect" {
  bucket = aws_s3_bucket.redirect_static_bucket.id

  redirect_all_requests_to {
    host_name = aws_s3_bucket.main_static_bucket.id
  }
}