# data source to get information about the default VPC in your account
data "aws_vpc" "default" {
  default = true
}

# data source to get all the subnets in the default vpc
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create a new AWS Secrets Manager secret to store the master password
resource "aws_secretsmanager_secret" "rds_password" {
  name = "${var.project_name}-rds-password"
}

# Store a randomly generated password in the secret
resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    username = var.db_username,
    password = random_password.master.result
  })
}

# Generate a random password for the database master user
resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


# Create an Aurora PostgreSQL-compatible Provisioned cluster required by Bedrock
resource "aws_rds_cluster" "main" {
  cluster_identifier   = "${var.project_name}-cluster"
  engine               = "aurora-postgresql"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  engine_mode          = "provisioned"
  engine_version       = "16.6" # A version compatible with pgvector
  database_name        = var.db_name
  master_username      = jsondecode(aws_secretsmanager_secret_version.rds_password.secret_string)["username"]
  master_password      = jsondecode(aws_secretsmanager_secret_version.rds_password.secret_string)["password"]
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot    = true
  enable_http_endpoint   = true
  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
    seconds_until_auto_pause = 3600
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }

  lifecycle {
    ignore_changes = [
      serverlessv2_scaling_configuration
    ]
  }
}

# Add a cluster instance, which is required for provisioned mode
resource "aws_rds_cluster_instance" "main" {
  cluster_identifier = aws_rds_cluster.main.id
  identifier         = "${var.project_name}-cluster-instance"
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  publicly_accessible = true
  tags = {
    Name = "${var.project_name}-cluster-instance"
  }
}

variable "db_username" {
  description = "The master username for the database."
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "bedrockkb"
}