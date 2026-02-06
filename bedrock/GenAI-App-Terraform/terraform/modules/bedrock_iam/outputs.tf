output "kb_role_arn" {
  value = aws_iam_role.kb.arn
  description = "ARN of the predefined IAM role for Bedrock Knowledge Base"
}
