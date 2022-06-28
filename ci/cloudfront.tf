locals {
  humble_s3_origin = "humble-s3-origin"
}

resource "aws_cloudfront_origin_access_identity" "origin" {}

resource "aws_cloudfront_distribution" "distribution" {
  aliases = [
    "humble-website.com",
    "humble-website.com.br",
  ]
  comment             = "Humble Website Distribution"
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
    target_origin_id       = local.humble_s3_origin
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  logging_config {
    bucket          = "humble-website.s3.amazonaws.com"
    include_cookies = false
    prefix          = "humble"
  }

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = local.humble_s3_origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["BR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = var.humble_environment
    Name        = "Humble Website Distribution"
  }
}
