# AWS Generative AI Portfolio

![AWS GenAI](aws_genai.jpeg)

This repository contains clear, production-oriented implementations of Generative AI serverless architectures on AWS. It demonstrates the practical application of Large Language Models (LLMs), Vector Databases, and Agentic workflows to solve real-world problems.

## Key Projects

### 1. [Serverless GenAI QA App](./bedrock/Serverless-GenAI-QA-App)
A full-stack RAG application that allows users to query a knowledge base using natural language.
- **Tech Stack**: Amazon Bedrock (Agents), Amazon Aurora PostgreSQL (pgvector), AWS Lambda, React, AWS Amplify.
- **Key Features**: Retrieval-Augmented Generation, vector similarity search (HNSW), and an interactive chat interface.

### 2. [Bedrock RAG System](./bedrock/RAG)
A deeper dive into the backend implementation of Retrieval-Augmented Generation.
- **Tech Stack**: Amazon Bedrock (Titan models), SQL-based Vector Store.
- **Focus**: Configuring high-performance vector indexes (GIN/HNSW) and secure knowledge base integration.

### 3. [Conversational RAG Agent](./bedrock/conversational-rag-agent)
An advanced agentic workflow capable of multi-turn conversations.
- **Tech Stack**: Amazon Bedrock Agents, Aurora PostgreSQL (1024-dim Layout).
- **Key Features**: Context retention, orchestrated retrieval, and higher-dimensional embedding support.

### 4. [GenAI App with Terraform](./bedrock/GenAI-App-Terraform)
A serverless architecture for document ingestion and QA, provisioned entirely with Terraform.
- **Tech Stack**: Terraform, Amazon Bedrock (Knowledge Bases, Guardrails), AWS Lambda, Amazon API Gateway.
- **Key Features**: Infrastructure as Code, automated ingestion pipeline, and responsible AI guardrails.

## Technologies Used
- **Generative AI**: Amazon Bedrock, Amazon SageMaker, Titan Embeddings, Foundational Models (FM).
- **Database**: Amazon Aurora PostgreSQL (`pgvector` extension).
- **Compute**: AWS Lambda (Serverless Python).
- **Infrastructure**: AWS IAM, Secrets Manager, S3.
- **Frontend**: React.js, AWS Amplify.

---
*Built to demonstrate scalable and secure AI solutions compliant with industry standards.*
