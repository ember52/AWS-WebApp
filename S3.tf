# =======================================================================================
# Create S3 bucket for hosting a static website with versioning enabled
# =======================================================================================
resource "aws_s3_bucket" "amplify_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name = "AmplifyAppBucket"
  }
}

# =======================================================================================
# create a configuration resource to enable static website hosting
# =======================================================================================
resource "aws_s3_bucket_website_configuration" "amplify_bucket_website_conf" {
  bucket = aws_s3_bucket.amplify_bucket.id

  index_document {
    suffix = "index.html"
  }

  # error_document {
  #   key = "error.html"
  # }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}

# =======================================================================================
# Disable block public ACLs and block public policies on the bucket
# =======================================================================================
resource "aws_s3_bucket_public_access_block" "amplify_bucket_block" {
  bucket = aws_s3_bucket.amplify_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "amplify_bucket_versioning" {
  bucket = aws_s3_bucket.amplify_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# =======================================================================================
# Set a bucket policy to allow public access to the files
# =======================================================================================
resource "aws_s3_bucket_policy" "amplify_bucket_policy" {
  bucket = aws_s3_bucket.amplify_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.amplify_bucket.arn}/*"
    }]
  })
}

# =======================================================================================
# Output the S3 website URL
# =======================================================================================
output "website_url" {
  value = aws_s3_bucket_website_configuration.amplify_bucket_website_conf.website_endpoint
}