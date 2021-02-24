CREATE USER executor PASSWORD '1234';

CREATE SCHEMA IF NOT EXISTS executor;

GRANT ALL ON SCHEMA executor TO executor;
GRANT ALL ON ALL SEQUENCES IN SCHEMA executor TO executor;

ALTER DEFAULT PRIVILEGES
    FOR USER postgres
    IN SCHEMA executor
    GRANT ALL ON TABLES TO executor;
ALTER DEFAULT PRIVILEGES
    FOR USER postgres
    IN SCHEMA executor
    GRANT ALL ON SEQUENCES TO executor;

ALTER USER executor SET search_path TO executor, public;
