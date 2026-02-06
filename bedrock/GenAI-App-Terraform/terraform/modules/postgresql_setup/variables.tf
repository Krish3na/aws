variable "main_cluster_endpoint" {
  description = "RDS cluster endpoint"
  type        = string
}

variable "rds_instance_id" {
  description = "ID of the RDS cluster instance"
  type        = string
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "bedrockkb"
}
