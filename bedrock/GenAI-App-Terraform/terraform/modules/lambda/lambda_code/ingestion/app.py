import boto3
import json
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize the correct Boto3 client for managing knowledge bases
bedrock_agent_client = boto3.client('bedrock-agent')

# Get environment variables
KNOWLEDGE_BASE_ID = os.environ.get('KNOWLEDGE_BASE_ID')

def get_s3_data_source_id(kb_id):
    """
    Scans the data sources of a knowledge base and returns the ID of the first
    one that is of type 'S3'.
    """
    try:
        response = bedrock_agent_client.list_data_sources(knowledgeBaseId=kb_id)
        data_sources = response.get('dataSourceSummaries', [])
        print(data_sources)
        
        for ds in data_sources:
            # Assuming there is only one S3 data source. 
            # This logic can be expanded to find a specific bucket if needed.
            if 'educative-s3-source' in ds.get('name', {}):
                logger.info(f"Found S3 data source with ID: {ds['dataSourceId']}")
                return ds['dataSourceId']
                
        logger.warning("No S3 data source found for the given knowledge base.")
        return None
    except Exception as e:
        logger.error(f"Error listing data sources: {e}")
        return None

def handler(event, context):
    """
    This function is triggered by an S3 event and starts an ingestion job
    in the Bedrock Knowledge Base for the associated S3 data source.
    """
    if not KNOWLEDGE_BASE_ID:
        logger.error("KNOWLEDGE_BASE_ID environment variable not set.")
        return {'statusCode': 500, 'body': json.dumps('Server configuration error.')}

    try:
        data_source_id = get_s3_data_source_id(KNOWLEDGE_BASE_ID)
        
        if not data_source_id:
            return {'statusCode': 404, 'body': json.dumps('No S3 data source found.')}

        logger.info(f"Starting ingestion for Knowledge Base ID: {KNOWLEDGE_BASE_ID} and Data Source ID: {data_source_id}")

        # Start the ingestion job using the dynamically found data source ID
        response = bedrock_agent_client.start_ingestion_job(
            knowledgeBaseId=KNOWLEDGE_BASE_ID,
            dataSourceId=data_source_id
        )
        
        ingestion_job = response.get('ingestionJob', {})
        job_id = ingestion_job.get('ingestionJobId', 'N/A')
        
        logger.info(f"Successfully started ingestion job with ID: {job_id}")

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Ingestion job started successfully.',
                'ingestionJobId': job_id
            })
        }

    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to start ingestion job.'})
        }

