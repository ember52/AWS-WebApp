# AWS WeatherCHecker WebApp

This project deploys a static website on an S3 bucket using Terraform, along with an API Gateway, Lambda function, and DynamoDB integration for backend functionality. The project automates infrastructure provisioning and creates the necessary AWS resources for hosting and interacting with the website.

## Prerequisites

Ensure you have the following before proceeding:
- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- An AWS account
- AWS CLI configured with the necessary credentials (`aws configure`), or you can alternatively use Global Variables for your credentials

## Project Structure

The repository contains the following files:

- **API_Gateway.tf**: Defines the API Gateway for interacting with the Lambda function. It includes a POST method that triggers the Lambda function and handles CORS headers.
- **DynamoDb.tf**: Creates a DynamoDB table for storing city names, weather status, and request timestamps.
- **File_Upload.tf**: Uploads the `index.html` file to the S3 bucket after updating it with the correct API Gateway invoke URL. It also compresses the Lambda code into a zip file and uploads it to the same bucket.
- **Lambda.tf**: Deploys a Lambda function to interact with the DynamoDB table and handle API Gateway requests by calling the OpenWeather API to retrieve weather data.
- **S3.tf**: Provisions the S3 bucket and configures it for static website hosting.
- **index.html.tpl**: Template for the website's HTML, dynamically injecting the API Gateway URL.
- **lambda_function.py**: Python code for the Lambda function.
- **provider.tf**: Configures the AWS provider and region.
- **terraform.tfvars**: Stores variable values, such as bucket name, region, and OpenWeatherMap API key.
- **variables.tf**: Declares input variables used throughout the Terraform configuration.
- **README.md**: Instructions for setting up and running the project (this file).


## Steps to Deploy

### 1. Clone the Repository

```bash
git clone https://github.com/ember52/AWS-WebApp.git
```

### 2. Modify the `terraform.tfvars` file

Update the `terraform.tfvars` file with the necessary values for your setup, such as the S3 bucket name (for the remote backend), AWS region, etc.

```hcl
s3_bucket      = "my-terraform-state-bucket"
state_file_key = "prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock-table"
```
For the S3 bucket that stores the Lambda code and hosts the web application:

```hcl
s3_bucket_name = "enter_your_preferred_bucket_name"
```

Make sure to enter your OpenWeatherMap API key:

```hcl
weather_api_key      = "your_actual_openweathermap_api_key" 
```

### 3. Initialize, Plan, Deploy Terraform

Initialize Terraform to download the required provider plugins and prepare the workspace.
```hcl
terraform init
terraform plan
terraform apply
```

Terraform will automatically use the terraform.tfvars file for the variable values. However, you can use your own values by specifying a different variable file:

```hcl
terraform apply -var-file="filename.tfvars"
```

### 4. Access the Hosted Website
Once the deployment is complete, the website URL and the API invoke URL will be displayed as an output. You can access the website by visiting the S3 bucket's endpoint.

![Url_Output](https://github.com/user-attachments/assets/41e8db55-a505-4a02-a1a6-37995ee91a8e)


### 5. Screenshots

Enter the name of a city to check its weather:

![Screenshot 2024-10-19 151751](https://github.com/user-attachments/assets/fc51b17d-79a8-4276-a0dc-e573c28e0cdf)

Output:

![Screenshot 2024-10-19 151740](https://github.com/user-attachments/assets/200e7c72-0d0f-4bab-aecf-29f7123b3c4c)

### 6. Clean up
To destroy the created resources and avoid unwanted AWS charges, run the following command:

```hcl
terraform destroy
```

