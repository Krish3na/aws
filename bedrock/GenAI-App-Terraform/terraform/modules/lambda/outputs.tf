output "presigned_url_name" {
  description = "Name of the presigned URL Lambda function"
  value       = aws_lambda_function.presigned_url.function_name
}

output "presigned_url_arn" {
  description = "Invoke ARN of the presigned URL Lambda function"
  value       = aws_lambda_function.presigned_url.arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by Lambda functions"
  value       = aws_iam_role.lambda.arn
}
