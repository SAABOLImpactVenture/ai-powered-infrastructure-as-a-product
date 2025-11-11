-- Connect as server admin to the 'postgres' database
-- psql "host=<fqdn> user=<admin> dbname=postgres sslmode=require"

-- Create application role and user with strong password
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'backstage_app') THEN
    CREATE ROLE backstage_app LOGIN PASSWORD :'app_password';
  END IF;
END$$;

-- Ensure database exists (Terraform creates it), then grant limited privileges
GRANT CONNECT ON DATABASE backstage TO backstage_app;
\c backstage

-- Limit default privileges
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO backstage_app;
GRANT CREATE ON SCHEMA public TO backstage_app;

-- Ownership and future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backstage_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO backstage_app;
