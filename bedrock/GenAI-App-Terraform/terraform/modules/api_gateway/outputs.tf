output "rest_api_id" {
  value       = aws_api_gateway_rest_api.main.id
  description = "API Gateway ID"
}

output "root_resource_id" {
  value       = aws_api_gateway_rest_api.main.root_resource_id
  description = "Root resource ID"
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.main.execution_arn
  description = "Execution ARN"
}

output "api_gateway_invoke_url" {
  value       = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}"
}

output "presigned_url_endpoint" {
  value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/generate-upload-url"
}

output "query_endpoint" {
  value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/query"
}
