# =======================================================================================
# 1- values for the AWS region and backend
# =======================================================================================
s3_bucket      = "my-terraform-state-bucket"
state_file_key = "prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock-table"

# =======================================================================================
# 2- values for the DynamoDB table
# =======================================================================================
dynamodb_table_name   = "WeatherChecker"
dynamodb_billing_mode = "PAY_PER_REQUEST"
hash_key              = "ID"
dynamodb_tags = {
  Name        = "WeatherCheckerTable"
  Environment = "Dev"
}

# =======================================================================================
# 3- values for the S3 Bucket
# =======================================================================================
s3_bucket_name = "enter_your_preferred_bucket_name" # enter the name of the bucket for storing the files

# =======================================================================================
# 4- values for the Lambda Function & OpenWeather API
# =======================================================================================
lambda_function_name = "WeatherCheckerLambda"
weather_api_key      = "your_actual_openweathermap_api_key" # enter the value of the OpenWeatherAPI key from your account

# =======================================================================================
# 5- variables for the API Gateway
# =======================================================================================
api_name         = "WeatherCheckerAPI"
deployment_stage = "test"
