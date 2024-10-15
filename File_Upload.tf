# =======================================================================================
# create a local file with the invoke url using the template
# =======================================================================================
resource "local_file" "index_with_url" {
  filename = "${path.module}/index.html"
  content = templatefile("${path.module}/index.html.tpl", {
    api_url = aws_api_gateway_deployment.weather_api_deployment.invoke_url # Existing API URL
  })
  depends_on = [
    aws_api_gateway_deployment.weather_api_deployment
  ]
}

# =======================================================================================
# upload the index file to the bucket
# =======================================================================================
resource "aws_s3_object" "index_file" {
  bucket       = aws_s3_bucket.amplify_bucket.bucket
  key          = "index.html"
  source       = local_file.index_with_url.filename
  content_type = "text/html"

  # Ensure this upload happens only after the local file is created
  depends_on = [
    local_file.index_with_url
  ]
}

# =======================================================================================
# Zip the Lambda Function Python code
# =======================================================================================

# Step 1: Create the zip file using null_resource
resource "null_resource" "lambda_zip" {
  triggers = {
    python_file_md5 = filemd5("${path.module}/lambda_function.py") # Trigger when the file changes
    apply_time      = timestamp()                                  # This changes on every apply
  }

  provisioner "local-exec" {
    command = <<-EOT
      if [ ! -f "${path.module}/lambda.zip" ]; then
        zip -j "${path.module}/lambda.zip" "${path.module}/lambda_function.py" && echo "Zip file created." || echo "Failed to create zip file."
      fi
    EOT
  }
}


# Step 2: Ensure the zip file is cleaned up on destroy
resource "null_resource" "cleanup_lambda_zip" {
  provisioner "local-exec" {
    command = "rm -f ${path.module}/lambda.zip" # Remove the zip file
  }

  # Ensure cleanup occurs after lambda_zip is uploaded
  depends_on = [aws_s3_object.lambda_zip_upload]
  triggers = {
    apply_time = timestamp() # This changes on every apply
  }
}

# =======================================================================================
# Upload the Lambda zip to S3
# =======================================================================================
resource "aws_s3_object" "lambda_zip_upload" {
  bucket = aws_s3_bucket.amplify_bucket.bucket # Replace with your S3 bucket name
  key    = "lambda.zip"
  source = "${path.module}/lambda.zip" # Full path to the zip file

  # Ensure the file is updated only when the zip file content changes
  etag = filemd5("${path.module}/lambda_function.py")

  depends_on = [null_resource.lambda_zip, aws_s3_bucket.amplify_bucket]
}
