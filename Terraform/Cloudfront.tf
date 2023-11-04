# locals {
#   s3_origin_id   = "aws_s3_bucket.resume_bucket.bucket"
#   s3_domain_name = "${aws_s3_bucket.resume_bucket.bucket}.s3-website.us-east-1.amazonaws.com"
# }

# resource "aws_cloudfront_distribution" "s3_distribution" {
#   origin {
#     domain_name = local.s3_domain_name
#     origin_id   = local.s3_origin_id

#     custom_origin_config {
#       http_port              = "80"
#       https_port             = "443"
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
#     }
#   }

#   enabled         = true
#   is_ipv6_enabled = true

#   default_cache_behavior {
#     allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = true

#       cookies {
#         forward = "all"
#       }
#     }

#     viewer_protocol_policy = "https-only"
#     min_ttl                = 0
#     default_ttl            = 0
#     max_ttl                = 0
#   }

#   price_class = "PriceClass_200"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Environment = "production"
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }

# output "bucket_regional_domain_name" {
#   value = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
# }

