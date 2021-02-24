CREATE USER frontend PASSWORD '1234';

CREATE SCHEMA IF NOT EXISTS frontend;

GRANT ALL ON SCHEMA frontend TO frontend;
GRANT ALL ON ALL SEQUENCES IN SCHEMA frontend TO frontend;

ALTER DEFAULT PRIVILEGES
    FOR USER postgres
    IN SCHEMA frontend
    GRANT ALL ON TABLES TO frontend;
ALTER DEFAULT PRIVILEGES
    FOR USER postgres
    IN SCHEMA frontend
    GRANT ALL ON SEQUENCES TO frontend;

ALTER USER frontend SET search_path TO frontend, public;