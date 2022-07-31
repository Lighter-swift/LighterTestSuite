-- Another Test Database in a subdirectory
BEGIN;

CREATE TABLE first_table (
  first_table_id INTEGER PRIMARY KEY
);

PRAGMA user_version = 1;
COMMIT;
