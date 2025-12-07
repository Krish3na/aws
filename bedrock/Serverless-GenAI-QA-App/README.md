# Serverless GenAI QA App with Amazon Bedrock

This project demonstrates how to build a Serverless Generative AI Question-Answering application using Amazon Bedrock, Amazon Aurora PostgreSQL, and AWS Lambda.

## Architecture

[![Architecture](Architecture.png)](https://youtu.be/Z5Pbr6rkqng)

You can watch the [demo and explanation video here](https://youtu.be/Z5Pbr6rkqng).

## Task Overview

The goal of this project is to create a Retrieval-Augmented Generation (RAG) application that allows users to query a knowledge base. The application uses Amazon Bedrock for the foundation models and Amazon Aurora PostgreSQL has the vector store.

## Implementation Details

The solution involves the following steps:

1.  **Vector Store Setup**: 
    -   An Amazon Aurora PostgreSQL cluster is configured to serve as a vector store.
    -   The `vector` extension is enabled in the database.
    -   A table is created to store vector embeddings, chunks, and metadata.
    -   Indexes are created using GIN (for text search) and HNSW (for vector similarity search).

2.  **Secrets Management**:
    -   Database credentials (username and password) are securely stored in AWS Secrets Manager to allow Amazon Bedrock to access the Aurora database.

3.  **Knowledge Base**:
    -   An Amazon Bedrock Knowledge Base is created, which connects to the Aurora vector store.
    -   It uses an S3 bucket as the data source for documents.

4.  **Backend Logic**:
    -   An AWS Lambda function (`lambda_function.py`) handles the application logic.
    -   It invokes the Bedrock Agent to process user queries and retrieve answers from the knowledge base.

## Files Included

-   `lambda_function.py`: The Python source code for the AWS Lambda function.
-   `KnowledgeBase_SQLCommands.sql`: SQL commands used to set up the schema, table, and indexes in Aurora PostgreSQL.
-   `Lambda-Bedrock-Agent-Role.json`: IAM policy document for the Lambda function.
-   `Educative-Bedrock-Role.json`: IAM policy document for the Bedrock role.
-   `instructions.xml`: Prompt instructions for the Bedrock Agent.
