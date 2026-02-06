output "query_lambda_name" {
  description = "Name of the query Lambda function"
  value       = aws_lambda_function.query.function_name
}

output "query_lambda_arn" {
  description = "Invoke ARN of the query Lambda"
  value       = aws_lambda_function.query.arn
}
