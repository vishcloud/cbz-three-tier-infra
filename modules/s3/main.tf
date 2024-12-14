# Create an S3 bucket
resource "aws_s3_bucket" "cbz_bucket" {
  bucket = "cbz-frontend-bux" # Replace with a globally unique bucket name

  # Enable static website hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "StaticWebsiteBucket"
    env = "dev"
  }
}

# Set the bucket policy to allow public read access (use cautiously)
resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.cbz_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cbz_bucket.arn}/*"
      }
    ]
  })
}

# Output the bucket's website endpoint
output "website_endpoint" {
  value       = aws_s3_bucket.cbz_bucket.website_endpoint
  description = "The URL to access the static website"
}
