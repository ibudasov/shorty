module "s3_bucket_storage" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "shorty-prod-storage"
  acl    = "public-read"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

module "s3_bucket_app" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "shorty-prod-app"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}