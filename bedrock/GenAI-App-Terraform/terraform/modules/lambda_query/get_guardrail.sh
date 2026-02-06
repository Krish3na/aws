#!/bin/bash
set -euo pipefail

# Read JSON input
input=$(cat)
GUARDRAIL_NAME=$(echo "$input" | jq -r '.guardrail_name')

if [ -z "$GUARDRAIL_NAME" ] || [ "$GUARDRAIL_NAME" == "null" ]; then
  echo "Error: guardrail_name is missing" >&2
  exit 1
fi

# Fetch guardrail info using AWS CLI
response=$(aws bedrock list-guardrails --region us-east-1 \
  --query "guardrails[?name=='${GUARDRAIL_NAME}'] | [0]" \
  --output json)

if [ -z "$response" ] || [ "$response" == "null" ]; then
  echo "Error: No guardrail found with name '${GUARDRAIL_NAME}'" >&2
  exit 1
fi

# Print JSON for Terraform
echo "$response"
