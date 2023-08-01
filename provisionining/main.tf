terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  shared_credentials_files = ["/Users/igor/.aws/credentials"]
}

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

