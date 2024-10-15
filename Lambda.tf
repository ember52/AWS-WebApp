# =======================================================================================
# IAM Role for Lambda Function
# =======================================================================================
resource "aws_iam_role" "lambda_role" {
  name = "lambda_dynamodb_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# =======================================================================================
# IAM Policy for Lambda to access DynamoDB and CloudWatch Logs
# =======================================================================================
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_dynamodb_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ],
        Effect   = "Allow",
        Resource = "${aws_dynamodb_table.weather_checker_table.arn}"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# =======================================================================================
# Attach policy to the IAM role
# =======================================================================================
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# =======================================================================================
# Create the Lambda Function
# =======================================================================================
resource "aws_lambda_function" "weather_checker_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  environment {
    variables = {
      WEATHER_API_KEY = var.weather_api_key
    }
  }

  s3_bucket = aws_s3_bucket.amplify_bucket.bucket
  s3_key    = "lambda.zip"

  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment, aws_s3_object.lambda_zip_upload]
}


# =======================================================================================
# Grant Lambda permissions to write logs to CloudWatch
# =======================================================================================
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_checker_lambda.function_name
  principal     = "logs.amazonaws.com"
}

# =======================================================================================
# Grant API Gateway permission to invoke the Lambda function
# =======================================================================================
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_checker_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.weather_api.execution_arn}/*/*"
}
