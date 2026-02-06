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

# Security group for the RDS database within the default VPC
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow traffic to RDS"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Rule to allow internet access to RDS at PostgreSQL port
resource "aws_security_group_rule" "internet_to_rds" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = ["0.0.0.0/0"]
}