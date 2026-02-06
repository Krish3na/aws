variable "presigned_lambda_arn" {
  description = "Invoke ARN of the presigned URL Lambda function"
  type        = string
}

variable "query_lambda_arn" {
  description = "Invoke ARN of the query Lambda function"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "presigned_lambda_name" {
  description = "Name of the presigned URL Lambda function"
  type        = string
}

variable "query_lambda_name" {
  description = "Name of the query Lambda function"
  type        = string
}


