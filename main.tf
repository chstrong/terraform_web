locals {
  s3_bucket_name = "thebeansprout-90u90uu"
  environment    = "dev"
  web_dir = "./webdir"
}

###########################################################
# S3 Configuration
###########################################################

# Create S3 Bucket
resource "aws_s3_bucket" "s3web" {
  bucket = local.s3_bucket_name
  tags = {
    Environment = local.environment
  }
}

## Enable AWS S3 file versioning
resource "aws_s3_bucket_versioning" "s3web" {
  bucket = aws_s3_bucket.s3web.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "s3web" {
  bucket                  = aws_s3_bucket.s3web.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###########################################################
# Cloudfront Configuration
###########################################################

## Create CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  depends_on = [
    aws_s3_bucket.s3web,
    aws_cloudfront_origin_access_control.cdn
  ]

  origin {
    domain_name              = aws_s3_bucket.s3web.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.s3web.id
    origin_access_control_id = aws_cloudfront_origin_access_control.cdn.id
  }

  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #restriction_type = "whitelist"
      #locations        = ["US", "CA"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.s3web.id
    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

###########################################################
# Setup Permissions between Cloudfront and S3
###########################################################

## Create Origin Access Control as this is required to allow access 
## to the s3 bucket without public access to the S3 bucket.
resource "aws_cloudfront_origin_access_control" "cdn" {
  name                              = "Security_Pillar100_CF_S3_OAC"
  description                       = "OAC setup for security pillar 100"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

## Create policy to allow CloudFront to reach S3 bucket
data "aws_iam_policy_document" "cdn2s3web" {
  depends_on = [
    aws_cloudfront_distribution.cdn,
    aws_s3_bucket.s3web
  ]
  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3web.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.cdn.arn
      ]
    }
  }
}

## Assign policy to allow CloudFront to reach S3 bucket
resource "aws_s3_bucket_policy" "cdn2s3web" {
  depends_on = [
    aws_cloudfront_distribution.cdn
  ]
  bucket = aws_s3_bucket.s3web.id
  policy = data.aws_iam_policy_document.cdn2s3web.json
}

###########################################################
# Upload Site
###########################################################

# Upload web directory to s3 bucket
resource "aws_s3_object" "bootstrap_files" {
  for_each = fileset(local.web_dir, "**")
  bucket = aws_s3_bucket.s3web.id
  key    = each.key
  source = "${local.web_dir}/${each.value}"
  etag   = filemd5("${local.web_dir}/${each.value}")
  content_type = "text/html"
}