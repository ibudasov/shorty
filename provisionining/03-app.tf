# App module

# The app module creates and manages the infrastructure needed to run the app tier application. 
# The compute part of the system is a Lambda function that is triggered by an API Gateway endpoint.

# This module contains these resources because they are highly encapsulated and have highly volatility.

# 1. The resources in this module are tightly scoped and associated specifically with the app 
# tier application. As a result, they should be grouped together into a single module so app 
# tier application team members can easily deploy them.
# 2. The resources in this module change often (with each code release). By separating them
# into a their own module, you decrease unnecessary churn and risk for other modules.

resource "aws_ecr_repository" "shorty_ecr_repo" {
  name                 = "shorty"
  // todo: make it immutable, when proper versioning and CI/CD is there
  image_tag_mutability = "MUTABLE"
}

resource "aws_lambda_function" "shorty" {
  function_name = "ServerlessShorty"
  timeout       = 5 # seconds
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.shorty_ecr_repo.repository_url}:latest"

  role = "${aws_iam_role.shorty_lambda_exec.arn}"

  environment {
    variables = {
      ENVIRONMENT = "prod"
      AWS_S3_BUCKET_NAME = aws_s3_bucket.shorty_bucket.bucket
    }
  }
}