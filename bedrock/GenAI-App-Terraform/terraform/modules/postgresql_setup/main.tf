resource "null_resource" "setup_kb" {
  triggers = {
    db_host     = var.main_cluster_endpoint
    db_password = var.rds_password
  }

  provisioner "local-exec" {
    command = <<EOT
psql <<SQL
CREATE EXTENSION IF NOT EXISTS vector;
CREATE TABLE IF NOT EXISTS bedrock_kb (
  id UUID PRIMARY KEY,
  embedding VECTOR(1024),
  chunks TEXT,
  metadata JSONB
);
CREATE INDEX ON bedrock_kb USING gin (to_tsvector('simple', chunks));
CREATE INDEX ON bedrock_kb USING hnsw (embedding vector_cosine_ops);
SQL
EOT

    environment = {
      PGPASSWORD = var.rds_password
      PGHOST     = var.main_cluster_endpoint
      PGUSER     = var.db_username
      PGDATABASE = var.db_name
      PGSSLMODE  = "require"
    }
  }

  depends_on = [var.rds_instance_id]
}
