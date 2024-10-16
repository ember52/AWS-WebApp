# =======================================================================================
# Create DynamoDB table for WeatherChecker
# =======================================================================================
resource "aws_dynamodb_table" "weather_checker_table" {
  name         = var.dynamodb_table_name
  billing_mode = var.dynamodb_billing_mode
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  tags = var.dynamodb_tags
}
