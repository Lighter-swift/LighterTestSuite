CREATE VIEW IF NOT EXISTS "A Test View" AS
  SELECT street, city
    FROM address BASE
    LEFT JOIN person P USING ( person_id )
   WHERE P.person_id BETWEEN 1 AND 3;

CREATE TABLE IF NOT EXISTS "A Fancy Test Table" (
  id INTEGER PRIMARY KEY,
  text TEXT NOT NULL
);
