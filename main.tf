terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "main_static_bucket" {
    bucket = "www.michalolszewski.click"
}

resource "aws_s3_bucket_public_access_block" "disable_public_block" {
    bucket = aws_s3_bucket.main_static_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_object" "upload_main_error" { 
    bucket = aws_s3_bucket.main_static_bucket.id
    key = "error.html"
    source = "error.html"
}

resource "aws_s3_bucket_object" "upload_main_index" { 
    bucket = aws_s3_bucket.main_static_bucket.id
    key = "index.html"
    source = "index.html"
}

resource "aws_s3_bucket_policy" "allow_main_getObject" {
    bucket = aws_s3_bucket.main_static_bucket.id
    policy = data.aws_iam_policy_document.allow_getObject_main.json
}

data "aws_iam_policy_document" "allow_getObject_main" {
    statement {
        sid = "PublicReadGetObject"
        principals {
            type = "*"
            identifiers = ["*"]
        }
        actions = [
            "s3:GetObject",
        ]
        resources = [
            aws_s3_bucket.main_static_bucket.arn, 
            "${aws_s3_bucket.main_static_bucket.arn}/*"
        ]
    }
}

resource "aws_s3_bucket_website_configuration" "static_web" {
  bucket = aws_s3_bucket.main_static_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}