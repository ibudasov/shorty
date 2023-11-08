resource "aws_iam_role" "shorty_lambda_exec" {
  name = "serverless_shorty_lambda"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

