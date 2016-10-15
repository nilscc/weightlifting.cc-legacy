CREATE SCHEMA IF NOT EXISTS Auth;

-- Uncomment to reset Auth database
DROP TABLE Auth.Sessions;
DROP TABLE Auth.Users;

CREATE TABLE IF NOT EXISTS Auth.Users
(
  id          SERIAL    PRIMARY KEY,
  name        TEXT      UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS Auth.Sessions
(
  id          SERIAL    PRIMARY KEY,
  key         UUID      UNIQUE NOT NULL,
  user_id     INTEGER   REFERENCES Auth.Users (id)
);

CREATE INDEX ON Auth.Sessions (key);
