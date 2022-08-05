-- This should not get picked up, because it lives in NoSQL
CREATE TABLE "I Should not Appear!" (
  "I Should not Appear Primary Key" INTEGER PRIMARY KEY
);
PRAGMA user_version = 42;
