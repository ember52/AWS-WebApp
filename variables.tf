# =======================================================================================
# 1- variables for the AWS region, backend and state lock database
# =======================================================================================

# Variable for the AWS Region
variable "region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

# Variable for the S3 bucket name
variable "s3_bucket" {
  type        = string
  description = "Name of the S3 bucket for storing Terraform state"
}

# Variable for the state file key
variable "state_file_key" {
  type        = string
  description = "Key (path) within the S3 bucket for the Terraform state file"
  default     = "terraform.tfstate" # You can change the default if needed
}

# Variable for the DynamoDB table
variable "dynamodb_table" {
  type        = string
  description = "Name of the DynamoDB table used for state locking"
}


# =======================================================================================
# 2- variables for the DynamoDB table
# =======================================================================================

# Variable for DynamoDB table name
variable "dynamodb_table_name" {
  type        = string
  description = "The name of the DynamoDB table"
  default     = "WeatherChecker" # You can change the default if needed
}

# Variable for billing mode (PAY_PER_REQUEST or PROVISIONED)
variable "dynamodb_billing_mode" {
  type        = string
  description = "The billing mode for the DynamoDB table (PAY_PER_REQUEST or PROVISIONED)"
  default     = "PAY_PER_REQUEST"
}

# Variable for the hash key
variable "hash_key" {
  type        = string
  description = "The hash key for the DynamoDB table"
  default     = "ID"
}

# Variable for table tags
variable "dynamodb_tags" {
  type        = map(string)
  description = "Tags for the DynamoDB table"
  default = {
    Name        = "WeatherCheckerTable"
    Environment = "Dev"
  }
}

# =======================================================================================
# 3- variables for the S3 bucket
# =======================================================================================
variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for hosting the static website"
  default     = "weather-checker-storage-bucket" # Provide a default, but you can change it
}


# =======================================================================================
# 4- variables for the Lambda Function & OpenWeather API
# =======================================================================================
# Variable for Lambda function name
variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
  default     = "WeatherCheckerLambda"
}

# Variable for OpenWeatherMap API key
variable "weather_api_key" {
  type        = string
  description = "The API key for OpenWeatherMap"
}


# =======================================================================================
# 5- variables for the API Gateway
# =======================================================================================
# Variable for API Gateway name
variable "api_name" {
  type        = string
  description = "The name of the API Gateway"
  default     = "WeatherCheckerAPI"
}

# Variable for deployment stage
variable "deployment_stage" {
  type        = string
  description = "Stage name for API Gateway deployment"
  default     = "test"
}