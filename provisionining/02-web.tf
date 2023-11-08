# Web module

# The web module creates and manages the infrastructure needed to run the web application. 
# Even though we do not use a typical web server, this configuration of HTTP paths and methods
# reminds of configuring a web server.

# This module contains these resources because they are highly encapsulated and have 
# highly volatility.

# 1.The resources in this module are tightly scoped and associated specifically with the 
# web application (for example, this module provisions an AMI containing the latest web 
# application code release). As a result, they are grouped together into a single module 
# so web application team members can easily deploy them.
# 2. The resources in this module change often (with each code release). By separating 
# them into their own module, you decrease unnecessary churn and risk for other modules.

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.shorty.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.app.lambda_function_invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.shorty.id
  resource_id   = aws_api_gateway_rest_api.shorty.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.shorty.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.app.lambda_function_invoke_arn
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.shorty.id
  parent_id   = aws_api_gateway_rest_api.shorty.root_resource_id
  path_part   = "{proxy+}" // this resource will match any request path
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.shorty.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}
