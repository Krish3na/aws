variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
  default     = "python3.9"
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "app.handler"
}

variable "lambda_timeout" {
  description = "Timeout in seconds for Lambda function"
  type        = number
  default     = 200
}

variable "lambda_role_arn"{
    description = "ARN of ClabLambdaRole"
    type        = string
}

variable "knowledge_base_id" {
  description = "ID of the Bedrock Knowledge Base to be used by the Lambda"
  type        = string
}

