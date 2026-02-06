# Bedrock Agent Knowledge Base
resource "aws_bedrockagent_knowledge_base" "main" {
  name     = "${var.project_name}-kb"
  role_arn = var.clab_bedrock_role_arn

  depends_on = [
    var.rds_instance_id
  ]

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:aws:bedrock:${var.region}::foundation-model/amazon.titan-embed-text-v2:0"
    }
  }

  storage_configuration {
    type = "RDS"
    rds_configuration {
      credentials_secret_arn = var.rds_password_secret_arn
      database_name          = var.db_name
      resource_arn           = var.main_cluster_arn
      table_name             = "bedrock_kb"
      field_mapping {
        metadata_field    = "metadata"
        primary_key_field = "id"
        text_field        = "chunks"
        vector_field      = "embedding"
      }
    }
  }
}

# Data source for the Knowledge Base
resource "aws_bedrockagent_data_source" "main" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.main.id
  name              = "${var.project_name}-s3-source"

  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = var.documents_bucket_arn
    }
  }
}
