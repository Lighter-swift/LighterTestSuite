-- Update to v2
BEGIN;

ALTER TABLE first_table ADD COLUMN lastname TEXT NOT NULL DEFAULT '';

PRAGMA user_version = 2;
COMMIT;
