variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the RDS cluster"
  type        = list(string)
}


