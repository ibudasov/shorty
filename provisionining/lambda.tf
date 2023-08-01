resource "aws_lambda_function" "shorty" {
  function_name = "ServerlessShorty"

  s3_bucket = "shorty-prod-app"
  s3_key    = "v1.0.0/shorty.zip"

  handler = "main.handler"
  runtime = "nodejs8.10"

  role = "${aws_iam_role.shorty_lambda_exec.arn}"
}

resource "aws_iam_role" "shorty_lambda_exec" {
  name = "serverless_shorty_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}