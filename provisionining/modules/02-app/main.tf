resource "aws_ecr_repository" "shorty_ecr_repo" {
  name = "shorty"
  // todo: make it immutable, when proper versioning and CI/CD is there
  image_tag_mutability = "MUTABLE"
}

resource "aws_lambda_function" "shorty" {
  function_name = "ServerlessShorty"
  timeout       = 5 # seconds
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.shorty_ecr_repo.repository_url}:latest"

  role = var.shorty_lambda_exec_policy_arn

  environment {
    variables = {
      ENVIRONMENT        = "prod"
      AWS_S3_BUCKET_NAME = var.bucket_name
    }
  }
}