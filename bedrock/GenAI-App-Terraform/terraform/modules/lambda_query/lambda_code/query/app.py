import boto3
import json
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize Bedrock clients
bedrock_agent_runtime = boto3.client('bedrock-agent-runtime')
bedrock_runtime = boto3.client('bedrock-runtime')

# Get environment variables from the Lambda function's configuration
KNOWLEDGE_BASE_ID = os.environ.get('KNOWLEDGE_BASE_ID')
BEDROCK_MODEL_ID = os.environ.get('BEDROCK_MODEL_ID')
GUARDRAIL_ID = os.environ.get('GUARDRAIL_ID')
GUARDRAIL_VERSION = os.environ.get('GUARDRAIL_VERSION')

def handler(event, context):
    """
    Handles user queries by retrieving context from the Bedrock Knowledge Base,
    applying a Guardrail, and generating an answer using the Bedrock Messages API.
    """
    # Ensure all required environment variables are present
    if not all([KNOWLEDGE_BASE_ID, BEDROCK_MODEL_ID, GUARDRAIL_ID, GUARDRAIL_VERSION]):
        logger.error("One or more required environment variables are not set.")
        return {'statusCode': 500, 'body': json.dumps({'error': 'Server configuration error.'})}

    try:
        body = json.loads(event.get('body', '{}'))
        query = body.get('query')

        if not query:
            return {'statusCode': 400, 'body': json.dumps({'error': 'query is required in the request body.'})}
        
        logger.info(f"Received query: {query}")

        # Step 1: Retrieve context from the Knowledge Base
        retrieval_response = bedrock_agent_runtime.retrieve(
            knowledgeBaseId=KNOWLEDGE_BASE_ID,
            retrievalQuery={'text': query},
            retrievalConfiguration={'vectorSearchConfiguration': {'numberOfResults': 3}}
        )
        
        retrieved_chunks = [result['content']['text'] for result in retrieval_response.get('retrievalResults', [])]

        if not retrieved_chunks:
            logger.warning("No relevant chunks found in the knowledge base.")
            return {
                'statusCode': 200,
                'body': json.dumps({'answer': "I couldn't find any relevant information in the documents to answer your question."})
            }

        context_string = "\n\n".join(retrieved_chunks)

        # Step 2: Construct the model prompt
        prompt = f"""Use the following context to answer the user's question.
If the answer is not in the context, say you don't have enough information.

Context:
{context_string}
"""

        messages = [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": f"{prompt}\n\nQuestion: {query}"
                    }
                ]
            }
        ]

        request_body = {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 2048,
            "messages": messages,
            "temperature": 0.1,
        }

        # Step 3: Invoke the model with Guardrail
        logger.info("Invoking model with Guardrail...")
        model_response = bedrock_runtime.invoke_model(
            modelId=BEDROCK_MODEL_ID,
            body=json.dumps(request_body),
            guardrailIdentifier=GUARDRAIL_ID,
            guardrailVersion=GUARDRAIL_VERSION,
            contentType="application/json",
            accept="application/json"
        )

        response_body = json.loads(model_response['body'].read())

        # Step 4: Handle Guardrail actions if any
        guardrail_assessment = response_body.get('amazon-bedrock-guardrailAssessment', {})
        guardrail_action = guardrail_assessment.get('action')

        if guardrail_action == 'GUARDRAIL_INTERVENED':
            logger.warning(f"Guardrail intervened: {guardrail_assessment}")
            answer = guardrail_assessment.get('outputs', [{}])[0].get(
                'text',
                'The Guardrail blocked the response and did not provide an alternative.'
            ).strip()
        else:
            # Handle both Claude-style and legacy Bedrock responses
            if "output" in response_body:
                # Older structure
                answer = response_body.get('output', {}).get('content', [{}])[0].get(
                    'text', 'Could not generate an answer.'
                ).strip()
            else:
                # Claude or other modern model structure
                contents = response_body.get('content', [])
                if contents and isinstance(contents, list) and "text" in contents[0]:
                    answer = contents[0]["text"].strip()
                else:
                    answer = "Could not generate an answer."


        logger.info(f"Final answer: {answer}")

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({'answer': answer})
        }

    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}", exc_info=True)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'An internal server error occurred.'})
        }
