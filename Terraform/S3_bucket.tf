## Bucket for Resume
resource "aws_s3_bucket" "resume_bucket" {
  bucket = "aahil-resume-001"

  tags = {
    Name        = "resume_bucket"
    Environment = "Dev"
  }
}

## Bucket Public Access for Resume
resource "aws_s3_bucket_public_access_block" "resume_bucket_public_access_block" {
  bucket = aws_s3_bucket.resume_bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

## Bucket Ownership for Resume
resource "aws_s3_bucket_ownership_controls" "resume_bucket_ownership_controls" {
  bucket = aws_s3_bucket.resume_bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## Bucket ACL for Resume
resource "aws_s3_bucket_acl" "my-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.resume_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.resume_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.resume_bucket.bucket
  acl    = "public-read"
}

## Bucket Policy for Resume
resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.resume_bucket.bucket

  policy = <<POLICY
{
  "Id": "Policy",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.resume_bucket.bucket}/*",
      "Principal": {
        "AWS": [
          "*"
        ]
      }
    }
  ]
}
POLICY
}

## Bucket Static Site Configuration for Resume
resource "aws_s3_bucket_website_configuration" "resume_static_website" {
  bucket = aws_s3_bucket.resume_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

output "website_url" {
  value = "http://${aws_s3_bucket.resume_bucket.bucket}.s3-website.us-east-1.amazonaws.com"
}
