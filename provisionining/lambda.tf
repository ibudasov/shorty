resource "aws_ecr_repository" "shorty_ecr_repo" {
  name                 = "igor-shorty"
  // todo: make it immutable, when proper versioning and CI/CD is there
  image_tag_mutability = "MUTABLE"
}

resource "aws_lambda_function" "shorty" {
  function_name = "ServerlessShorty"
  timeout       = 5 # seconds
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.shorty_ecr_repo.repository_url}:latest"

  s3_bucket = "shorty-prod-app"
  s3_key    = "v1.0.0/shorty.zip"

  handler = "main.handler"
  runtime = "nodejs8.10"

  role = "${aws_iam_role.shorty_lambda_exec.arn}"

  environment {
    variables = {
      ENVIRONMENT = "prod"
    }
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