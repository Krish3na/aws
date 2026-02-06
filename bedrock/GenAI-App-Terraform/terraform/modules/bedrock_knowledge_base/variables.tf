variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "main_cluster_arn" {
  description = "ARN of the RDS cluster to be used by the knowledge base"
  type        = string
}

variable "rds_password_secret_arn" {
  description = "ARN of the Secrets Manager secret that stores the RDS password"
  type        = string
}

variable "documents_bucket_arn" {
  description = "ARN of the S3 documents bucket used for knowledge base storage"
  type        = string
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
}

variable "clab_bedrock_role_arn" {
  description = "The ARN of the predefined IAM role for Bedrock KB"
  type        = string
}

variable "rds_instance_id" {
  description = "ID of the RDS cluster instance used by the Bedrock Knowledge Base"
  type        = string
}



