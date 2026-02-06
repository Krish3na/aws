import boto3
import json
import os
import uuid
from botocore.exceptions import ClientError
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize the S3 client
s3_client = boto3.client('s3')

# Get environment variables
DOCUMENT_BUCKET_NAME = os.environ.get('DOCUMENT_BUCKET_NAME')

def handler(event, context):
    """
    Generates a presigned URL for uploading a file to an S3 bucket.
    The client must specify the 'fileName' in the request body.
    """
    if not DOCUMENT_BUCKET_NAME:
        logger.error("DOCUMENT_BUCKET_NAME environment variable not set.")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Server configuration error.'})
        }

    try:
        # Get the file name from the request body
        body = json.loads(event.get('body', '{}'))
        file_name = body.get('fileName')

        if not file_name:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'fileName is required in the request body.'})
            }
        
        # Generate a unique key for the S3 object
        object_key = f"uploads/{uuid.uuid4()}-{file_name}"

        # Generate the presigned URL
        presigned_url = s3_client.generate_presigned_url(
            'put_object',
            Params={
                'Bucket': DOCUMENT_BUCKET_NAME,
                'Key': object_key,
            },
            ExpiresIn=3600  # URL expires in 1 hour
        )

        logger.info(f"Generated presigned URL for {object_key}")

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*', # Adjust for production
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST'
            },
            'body': json.dumps({
                'uploadUrl': presigned_url,
                'key': object_key
            })
        }

    except ClientError as e:
        logger.error(f"Boto3 client error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Could not generate presigned URL.'})
        }
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'An internal server error occurred.'})
        }
