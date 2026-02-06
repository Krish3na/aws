# Archive the Python code for each Lambda function
data "archive_file" "presigned_url" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/presigned_url"
  output_path = "${path.module}/lambda_code/presigned_url.zip"
}

data "archive_file" "ingestion" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/ingestion"
  output_path = "${path.module}/lambda_code/ingestion.zip"
}

# IAM role for all Lambda functions
resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Attach a policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  role       = aws_iam_role.lambda.name
  policy_arn = var.lambda_policy_arn
}

# Lambda function to generate S3 presigned URLs
resource "aws_lambda_function" "presigned_url" {
  filename      = data.archive_file.presigned_url.output_path
  function_name = "${var.project_name}-presigned-url-lambda"
  role          = aws_iam_role.lambda.arn
  handler       = "app.handler"
  runtime       = "python3.9"
  timeout       = 30

  environment {
    variables = {
      DOCUMENT_BUCKET_NAME = var.documents_bucket_name
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_attachment]
}

# Lambda function to handle document ingestion
resource "aws_lambda_function" "ingestion" {
  filename      = data.archive_file.ingestion.output_path
  function_name = "${var.project_name}-ingestion-lambda"
  role          = aws_iam_role.lambda.arn
  handler       = "app.handler"
  runtime       = "python3.9"
  timeout       = 300

  environment {
    variables = {
      KNOWLEDGE_BASE_ID = var.knowledge_base_id
      DATA_SOURCE_ID    = var.data_source_id
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_attachment]
}

# Permission for S3 to invoke the ingestion Lambda
resource "aws_lambda_permission" "s3_invoke_ingestion" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingestion.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.documents_bucket_arn
}

# S3 event notification to trigger the ingestion Lambda function
resource "aws_s3_bucket_notification" "documents_notification" {
  bucket = var.documents_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.ingestion.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.s3_invoke_ingestion]
}
