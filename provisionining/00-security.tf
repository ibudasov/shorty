# Security module

# The security module creates and manages the infrastructure needed for any security. 
# It contains IAM resources. It could also include security groups and MFA.
# This module contains these resources because they are highly privileged and have low volatility.
# 1. Only members of the application team that have permission to create or modify IAM/security 
# resources should be able to use this module.
# 2. The team is unlikely to change the resources in this module often, so making them a separate 
# module decreases unnecessary churn and risk.
# https://registry.terraform.io/providers/-/aws/latest/docs/resources/s3_bucket_acl


# DataSource to generate a policy document
data "aws_iam_policy_document" "public_read_access" {
  // todo: make this policy more strict
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.shorty_bucket.arn,
      "${aws_s3_bucket.shorty_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role" "shorty_lambda_exec" {
  name = "serverless_shorty_lambda"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}