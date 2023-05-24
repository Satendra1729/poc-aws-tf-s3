terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "dynamotos3test1"
    key = "prod"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = "tf-satendrakk.com"

  tags = {
    Name        = "tf-satendrakk.com"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket       = aws_s3_bucket.test-bucket.id
  key          = "index.html"
  source       = "index.html"
  etag         = filemd5("index.html")
  content_type = "text/html"

}

resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.test-bucket.id

  block_public_policy = false
}

resource "aws_s3_bucket_policy" "test-bucket-bucket-policy" {
  bucket = aws_s3_bucket.test-bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid" : "PublicReadGetObject",
      "Effect": "Allow",
	    "Principal": "*",
      "Action": [ "s3:GetObject" ],
      "Resource": [
        "${aws_s3_bucket.test-bucket.arn}",
        "${aws_s3_bucket.test-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket_website_configuration" "test-bucket-bucket-website" {
  bucket = aws_s3_bucket.test-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}
