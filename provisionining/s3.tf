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

#https://registry.terraform.io/providers/-/aws/latest/docs/resources/s3_bucket_acl

#Resource to add bucket policy to a bucket
resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.shorty_bucket.id
  policy = data.aws_iam_policy_document.public_read_access.json
}

#DataSource to generate a policy document
data "aws_iam_policy_document" "public_read_access" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ReadObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.shorty_bucket.arn,
      "${aws_s3_bucket.shorty_bucket.arn}/*",
    ]
  }
}