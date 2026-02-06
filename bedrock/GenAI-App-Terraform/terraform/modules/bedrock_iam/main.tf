# IAM role for the Bedrock Knowledge Base
resource "aws_iam_role" "kb" {
  name = "ClabBedrockRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "bedrock.amazonaws.com"
      }
    }]
  })
}

# Attach existing ClabBedrockPolicy to KB role
resource "aws_iam_role_policy_attachment" "kb" {
  role       = aws_iam_role.kb.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ClabBedrockPolicy"
}

# Get current AWS account ID for policy ARN reference
data "aws_caller_identity" "current" {}
