provider "aws" {
  region     = var.region

}

# =======================================================================================
# to use a different backend (S3 bucket and DynamoDB table)
# =======================================================================================
# terraform {
#   backend "s3" {
#     bucket         = var.s3_bucket         
#     key            = var.state_file_key    
#     region         = var.region            
#     dynamodb_table = var.dynamodb_table    
#     encrypt        = true                  
#   }
# }

