terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
      configuration_aliases = [aws.us]
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}


provider "aws" {
  alias = "us"
  region = "us-east-1"
}



resource "aws_s3_bucket" "main" {
  bucket = "<your_domain_name>"
}

resource "aws_s3_bucket_public_access_block" "main_access_block" {
  bucket = aws_s3_bucket.main.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "main_index" { 
  bucket = aws_s3_bucket.main.id
  key = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "main_error" {
  bucket = aws_s3_bucket.main.id
  key = "error.html"
  source = "error.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "main_web" {
  bucket = aws_s3_bucket.main.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

data "aws_iam_policy_document" "AllowGetObject_main" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.main.arn, 
      "${aws_s3_bucket.main.arn}/*"
    ]
    sid = "AllowGetObjectMain"
  }
}

resource "aws_s3_bucket_policy" "main_policy" {
  bucket = aws_s3_bucket.main.id
policy = data.aws_iam_policy_document.AllowGetObject_main.json
}