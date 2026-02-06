# Create a Bedrock Guardrail to monitor and filter prompts and responses
resource "aws_bedrock_guardrail" "main" {
  name = "educative-guardrail"

  # The message returned to the user when their input prompt is blocked
  blocked_input_messaging = "Your prompt has been blocked because it violates our content policy."

  # The message returned when the model's response is blocked
  blocked_outputs_messaging = "The model's response was blocked because it violates our content policy."

  # All content policies must be nested within a single content_policy_config block.
  content_policy_config {
    filters_config {
      type = "HATE"
      # FIX: Replaced 'strength' with specific input and output strengths.
      input_strength  = "HIGH"
      output_strength = "HIGH"
    }
    filters_config {
      type = "SEXUAL"
      input_strength  = "HIGH"
      output_strength = "HIGH"
    }
    filters_config {
      type = "VIOLENCE"
      input_strength  = "HIGH"
      output_strength = "HIGH"
    }
    filters_config {
      type = "MISCONDUCT"
      input_strength  = "HIGH"
      output_strength = "HIGH"
    }
  }

  # PII entities must be nested within a sensitive_information_policy_config block.
  sensitive_information_policy_config {
    pii_entities_config {
      type   = "EMAIL"
      action = "BLOCK"
    }
    pii_entities_config {
      type   = "PHONE"
      action = "BLOCK"
    }
    pii_entities_config {
      type   = "ADDRESS"
      action = "BLOCK"
    }
  }

  # Denied words must be nested within a word_policy_config block.
  word_policy_config {
    words_config {
      text = "secret password"
    }
    words_config {
      text = "confidential project"
    }
  }

  tags = {
    Name = "educative-guardrail"
  }
}

