# Database module

# The database module creates and manages the infrastructure needed to run the database.
# In our case persistent storage is represented by S3 bucket which is good enough for our purpose

# This module contains these resources because they are highly privileged and have low volatility.

# 1. Only members of the application team that have permission to create or modify database 
# resources should be able to use this module.
# 2. The team is unlikely to change the resources in this module often, so making them a 
# separate module decreases unnecessary churn and risk.


resource "aws_s3_bucket" "shorty_bucket" {
  bucket = "shorty-prod-storage"
  force_destroy = true

}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.shorty_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "pb" {
  bucket = aws_s3_bucket.shorty_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership]
  bucket = aws_s3_bucket.shorty_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.shorty_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "remove_old_objects" {
  bucket = aws_s3_bucket.shorty_bucket.id
  rule {
    status = "Enabled"
    id     = "expire_all_files"
    expiration {
      days = 90
    }
  }
}

# Resource to add bucket policy to a bucket
resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.shorty_bucket.id
  policy = data.aws_iam_policy_document.public_read_access.json
}
