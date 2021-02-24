CREATE USER compiler PASSWORD '1234';

CREATE SCHEMA IF NOT EXISTS compiler;
GRANT ALL ON SCHEMA compiler TO compiler;
GRANT ALL ON ALL SEQUENCES IN SCHEMA compiler TO compiler;

ALTER DEFAULT PRIVILEGES
    FOR USER postgres
    IN SCHEMA compiler
    GRANT ALL ON TABLES TO compiler;
ALTER DEFAULT PRIVILEGES
    FOR USER postgres
    IN SCHEMA compiler
    GRANT ALL ON SEQUENCES TO compiler;

ALTER USER compiler SET search_path TO compiler, public;
