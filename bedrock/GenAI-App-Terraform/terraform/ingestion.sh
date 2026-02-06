#!/bin/bash

# Step 1: Request the presigned URL and save it to a variable named UPLOAD_URL
# We use 'jq' to parse the JSON response and extract only the URL.
echo "Requesting secure upload URL..."
UPLOAD_URL=$(curl -s -X POST \
  "$(terraform output -raw api_gateway_invoke_url)/generate-upload-url" \
  -H "Content-Type: application/json" \
  -d '{"fileName": "SampleReport.pdf"}' | jq -r .uploadUrl)

# Step 2: Use the UPLOAD_URL variable to upload the file directly to S3
if [ -n "$UPLOAD_URL" ] && [ "$UPLOAD_URL" != "null" ]; then
  echo "URL received. Uploading file..."
  curl -X PUT --upload-file ./SampleReport.pdf "$UPLOAD_URL"
  echo -e "\nUpload complete."
else
  echo "Failed to retrieve the upload URL."
fi
