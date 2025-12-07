# AWS Generative AI Portfolio

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

## Technologies Used
- **Generative AI**: Amazon Bedrock, Titan Embeddings, Foundational Models (FM).
- **Database**: Amazon Aurora PostgreSQL (`pgvector` extension).
- **Compute**: AWS Lambda (Serverless Python).
- **Infrastructure**: AWS IAM, Secrets Manager, S3.
- **Frontend**: React.js, AWS Amplify.

---
*Built to demonstrate scalable and secure AI solutions compliant with industry standards.*
