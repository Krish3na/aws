output "main_cluster_arn" {
  value = aws_rds_cluster.main.arn
}

output "main_instance_id" {
  value = aws_rds_cluster_instance.main.id
}

output "rds_password_secret_arn" {
  value = aws_secretsmanager_secret.rds_password.arn
}

output "main_cluster_endpoint" {
  value = aws_rds_cluster.main.endpoint
}

output "rds_password_secret_value" {
  value = jsondecode(aws_secretsmanager_secret_version.rds_password.secret_string)["password"]
}

