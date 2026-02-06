output "documents_bucket_name" {
  description = "The name of the S3 bucket for storing documents."
  value       = aws_s3_bucket.documents.id
}

output "documents_bucket_arn" {
  description = "The ARN of the S3 bucket for storing documents."
  value = aws_s3_bucket.documents.arn
}
