CREATE EXTENSION IF NOT EXISTS vector;

CREATE SCHEMA bedrock_integration;

CREATE TABLE bedrock_integration.bedrock_kb (
    id UUID PRIMARY KEY,
    embedding VECTOR(256),
    chunks TEXT,
    metadata JSON
);

CREATE INDEX ON bedrock_integration.bedrock_kb USING gin (to_tsvector('simple', chunks));

CREATE INDEX ON bedrock_integration.bedrock_kb USING hnsw (embedding vector_cosine_ops) WITH (ef_construction=256);