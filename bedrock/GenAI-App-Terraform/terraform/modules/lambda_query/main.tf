data "archive_file" "query" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/query"
  output_path = "${path.module}/lambda_code/query.zip"
}

data "external" "guardrail_info" {
  program = ["bash", "${path.module}/get_guardrail.sh"]

  query = {
    guardrail_name = "educative-guardrail"
  }
}

locals {
  guardrail_id      = data.external.guardrail_info.result.id
  guardrail_version = data.external.guardrail_info.result.version
}

# Data source to get information about the current AWS account
data "aws_caller_identity" "current" {}

locals {
  bedrock_inference_profile_arn = "arn:aws:bedrock:us-east-1:${data.aws_caller_identity.current.account_id}:inference-profile/us.anthropic.claude-3-5-haiku-20241022-v1:0"
}

# Lambda function to handle user queries
resource "aws_lambda_function" "query" {
  filename      = data.archive_file.query.output_path
  function_name = "${var.project_name}-query-lambda"
  role          = var.lambda_role_arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout

  environment {
    variables = {
      KNOWLEDGE_BASE_ID = var.knowledge_base_id
      GUARDRAIL_ID      = local.guardrail_id
      GUARDRAIL_VERSION = local.guardrail_version
      BEDROCK_MODEL_ID  = local.bedrock_inference_profile_arn
    }
  }
}
