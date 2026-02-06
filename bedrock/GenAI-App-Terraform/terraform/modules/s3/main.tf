# Create an S3 bucket to store uploaded documents
resource "aws_s3_bucket" "documents" {
  bucket = "${var.project_name}-documents-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-documents"
  }
}

# CORS configuration to allow uploads from a web browser via presigned URLs
resource "aws_s3_bucket_cors_configuration" "documents" {
  bucket = aws_s3_bucket.documents.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"] 
    expose_headers  = ["ETag"]
  }
}

data "aws_caller_identity" "current" {}
