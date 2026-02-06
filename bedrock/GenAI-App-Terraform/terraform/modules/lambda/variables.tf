variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "documents_bucket_name" {
  description = "The name of the S3 bucket used for documents"
  type        = string
}

variable "documents_bucket_arn" {
  description = "The ARN of the S3 bucket used for documents"
  type        = string
}

variable "knowledge_base_id" {
  description = "ID of the Bedrock knowledge base"
  type        = string
}

variable "data_source_id" {
  description = "ID of the Bedrock data source"
  type        = string
}

variable "lambda_policy_arn" {
  description = "ARN of the IAM policy to attach to Lambda functions"
  type        = string
}
