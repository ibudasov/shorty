output "lambda_function_name" {
  value = aws_lambda_function.shorty.function_name
}

output "lambda_function_invoke_arn" {
  value = aws_lambda_function.shorty.invoke_arn
}