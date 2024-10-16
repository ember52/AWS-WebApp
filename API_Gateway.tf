# =======================================================================================
#  Create API Gateway
# =======================================================================================
resource "aws_api_gateway_rest_api" "weather_api" {
  name        = var.api_name
  description = "API for Weather Checker Lambda"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# =======================================================================================
# Create POST method with Lambda Proxy integration directly under "/"
# =======================================================================================
resource "aws_api_gateway_method" "weather_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.weather_api.id
  resource_id   = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

# =======================================================================================
# Lambda integration for the POST method
# =======================================================================================
resource "aws_api_gateway_integration" "weather_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.weather_api.id
  resource_id             = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method             = aws_api_gateway_method.weather_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  passthrough_behavior    = "WHEN_NO_MATCH"
  uri                     = aws_lambda_function.weather_checker_lambda.invoke_arn
}

# =======================================================================================
# Integration response for POST method
# =======================================================================================
resource "aws_api_gateway_integration_response" "post_method_integration_response" {
  depends_on = [aws_api_gateway_integration.weather_lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method = aws_api_gateway_method.weather_post_method.http_method
  status_code = aws_api_gateway_method_response.post_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.json('$.body')" # Directly extract the 'body' from the Lambda response
  }
}

# =======================================================================================
# Method response for POST method
# =======================================================================================
resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method = aws_api_gateway_method.weather_post_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# =======================================================================================
# OPTIONS method for CORS on the root resource
# =======================================================================================
resource "aws_api_gateway_method" "weather_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.weather_api.id
  resource_id   = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# =======================================================================================
# OPTIONS integration
# =======================================================================================
resource "aws_api_gateway_integration" "weather_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method = aws_api_gateway_method.weather_options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({ "statusCode" : 200 })
  }
}

# =======================================================================================
# Integration response for OPTIONS method
# =======================================================================================
resource "aws_api_gateway_integration_response" "options_method_integration_response" {
  depends_on  = [aws_api_gateway_integration.weather_options_integration]
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method = aws_api_gateway_method.weather_options_method.http_method
  status_code = aws_api_gateway_method_response.options_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
}

# =======================================================================================
# Method response for OPTIONS method
# =======================================================================================
resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_rest_api.weather_api.root_resource_id
  http_method = aws_api_gateway_method.weather_options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

# =======================================================================================
# Deploy the API Gateway
# =======================================================================================
resource "aws_api_gateway_deployment" "weather_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.weather_lambda_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  stage_name  = var.deployment_stage

}

# =======================================================================================
# Output the API URL
# =======================================================================================
output "weather_api_url" {
  value = aws_api_gateway_deployment.weather_api_deployment.invoke_url
}
