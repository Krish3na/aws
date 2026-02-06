# Define project-wide variables that are used to name and tag resources.
variable "project_name" {
  description = "A unique name for the project to prefix resources."
  type        = string
  default     = "educative"
}

variable "region" {
  default = "us-east-1"
}

terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  region       = var.region
}

module "security_groups" {
  source       = "./modules/security_groups"
  project_name = var.project_name
  region       = var.region
}

variable "db_name" {
  description = "The name of the RDS database for the Knowledge Base"
  type        = string
  default     = "bedrockkb"  # optional default
}

variable "db_username" {
  description = "The master username for the RDS database"
  type        = string
  default     = "postgres"
}

module "rds" {
  source            = "./modules/rds"
  project_name      = var.project_name
  region            = var.region
  security_group_ids = [module.security_groups.rds_sg_id]
}

module "postgresql_setup" {
  source                  = "./modules/postgresql_setup"
  main_cluster_endpoint   = module.rds.main_cluster_endpoint
  rds_password            = module.rds.rds_password_secret_value
  db_username             = var.db_username
  db_name                 = var.db_name
  rds_instance_id         = module.rds.main_instance_id
}

module "bedrock_iam" {
  source       = "./modules/bedrock_iam"
  project_name = var.project_name
  region       = var.region
}

module "bedrock_knowledge_base" {
  source                  = "./modules/bedrock_knowledge_base"
  project_name            = var.project_name
  region                  = var.region
  db_name                 = var.db_name
  main_cluster_arn        = module.rds.main_cluster_arn
  rds_instance_id         = module.rds.main_instance_id
  rds_password_secret_arn = module.rds.rds_password_secret_arn
  documents_bucket_arn    = module.s3.documents_bucket_arn
  clab_bedrock_role_arn   = module.bedrock_iam.kb_role_arn
}

module "lambda" {
  source = "./modules/lambda"
  project_name          = var.project_name
  lambda_policy_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ClabLambdaPolicy"
  documents_bucket_name = module.s3.documents_bucket_name
  documents_bucket_arn  = module.s3.documents_bucket_arn
  knowledge_base_id     = module.bedrock_knowledge_base.knowledge_base_id
  data_source_id        = module.bedrock_knowledge_base.data_source_id
}

module "lambda_query" {
  source = "./modules/lambda_query"
  project_name      = var.project_name
  lambda_role_arn   = module.lambda.lambda_role_arn
  knowledge_base_id = module.bedrock_knowledge_base.knowledge_base_id
}

module "api_gateway" {
  source                      = "./modules/api_gateway"
  region                      = var.region
  project_name                = var.project_name
  presigned_lambda_arn        = module.lambda.presigned_url_arn
  presigned_lambda_name       = module.lambda.presigned_url_name
  query_lambda_arn            = module.lambda_query.query_lambda_arn
  query_lambda_name           = module.lambda_query.query_lambda_name
}