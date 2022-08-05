-- Update to v3
BEGIN;

ALTER TABLE first_table RENAME COLUMN lastname TO last_name;
ALTER TABLE first_table ADD COLUMN first_name TEXT NOT NULL DEFAULT '';

CREATE TABLE second_table AS SELECT * FROM first_table;

PRAGMA user_version = 3;
COMMIT;
