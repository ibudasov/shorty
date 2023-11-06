# Routing module

# The routing module creates and manages the infrastructure needed for any network routing. 
# Routing is represented by API Gateway, which routes the traffic to the compute resources.
# This module contains these resources because they are highly privileged and have low volatility.
# 1. Only members of the application team that have permission to create or modify routing resources
#  should be able to use this module.
# 2. The team is unlikely to change the resources in this module often, so making them a separate 
# module decreases unnecessary churn and risk.


resource "aws_api_gateway_rest_api" "shorty" {
  name        = "ServerlessShorty"
  description = "Serverless Application Shorty"
}

resource "aws_api_gateway_deployment" "shorty" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = "${aws_api_gateway_rest_api.shorty.id}"
  stage_name  = "prod"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.shorty.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.shorty.execution_arn}/*/*"
}