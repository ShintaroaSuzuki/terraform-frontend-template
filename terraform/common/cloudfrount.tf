resource "aws_cloudfront_response_headers_policy" "index_file" {
  name    = "index"
  comment = "index"

  custom_headers_config {
    items {
      header = "Cache-Control"
      override = true
      value = "no-cache"
    }
  }
}

resource "aws_cloudfront_distribution" "cf" {
  /* aliases = [var.domain] */

  origin {
    domain_name = aws_s3_bucket.for_client.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.for_client.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.for_client.cloudfront_access_identity_path
    }
  }

  enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.for_client.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/index.html"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.for_client.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    response_headers_policy_id = aws_cloudfront_response_headers_policy.index_file.id
  }

  /* custom_error_response { */
  /*   error_code         = 403 */
  /*   response_code      = 200 */
  /*   response_page_path = "/" */
  /* } */

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    /* acm_certificate_arn            = aws_acm_certificate.cert.arn */
    /* ssl_support_method             = "sni-only" */
    /* minimum_protocol_version       = "TLSv1" */
  }
}

resource "aws_cloudfront_origin_access_identity" "for_client" {}
