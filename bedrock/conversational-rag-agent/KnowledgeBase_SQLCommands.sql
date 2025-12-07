/* Start by enabling vector operations, essential for embeddings */
CREATE EXTENSION IF NOT EXISTS vector;

/* Next, create a dedicated space for our knowledge base */
CREATE SCHEMA bedrock_integration;

/* Next, define the table to store knowledge base chunks, embeddings, and metadata */
CREATE TABLE bedrock_integration.bedrock_kb (
    id UUID PRIMARY KEY,
    embedding VECTOR(1024),
    chunks TEXT,
    metadata JSON
);

/* Index for efficient full-text search on the text chunks */
CREATE INDEX ON bedrock_integration.bedrock_kb USING gin (to_tsvector('simple', chunks));

/*Index for fast similarity search on vector embeddings (HNSW with cosine similarity) */
CREATE INDEX ON bedrock_integration.bedrock_kb USING hnsw (embedding vector_cosine_ops) WITH (ef_construction=256);

/* Creates the dedicated database user for Bedrock integration. Remember to replace <password_for_user> with your chosen password. */
CREATE ROLE bedrock_edu_user WITH PASSWORD 'user_password' LOGIN;

/* Grant all necessary permissions on the schema to the new user */
GRANT ALL ON SCHEMA bedrock_integration TO bedrock_edu_user;

/* Sets the new user as the owner of the knowledge base table */
ALTER TABLE bedrock_integration.bedrock_kb OWNER TO bedrock_edu_user;