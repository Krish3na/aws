output "knowledge_base_id" {
  description = "The ID of the Bedrock knowledge base"
  value       = aws_bedrockagent_knowledge_base.main.id
}

output "data_source_id" {
  description = "The ID of the Bedrock data source"
  value       = aws_bedrockagent_data_source.main.id
}
