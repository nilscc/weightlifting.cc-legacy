CREATE SCHEMA IF NOT EXISTS Training;

-- Uncomment to reset training database
/*
DROP TABLE Training.WorkoutSet;
DROP TABLE Training.WorkoutExercises;
DROP TABLE Training.Workouts;
DROP TABLE Training.Exercises;
*/

-- Table for names of exercises
CREATE TABLE IF NOT EXISTS Training.Exercises
(
  id                  SERIAL          PRIMARY KEY,
  name                TEXT            NOT NULL UNIQUE
);

-- Exercises will typically be used by name, so create an index on it
CREATE INDEX ON Training.Exercises (name);

-- Table for workouts
CREATE TABLE IF NOT EXISTS Training.Workouts
(
  id                  SERIAL          PRIMARY KEY,
  user_id             INTEGER         NOT NULL REFERENCES Auth.Users (id),
  date                DATE            NOT NULL
);

CREATE TABLE IF NOT EXISTS Training.WorkoutExercises
(
  id                  SERIAL          PRIMARY KEY,
  exercise_id         INTEGER         NOT NULL
                                      REFERENCES Training.Exercises (id)
                                      ON DELETE RESTRICT
                                      ON UPDATE RESTRICT,
  workout_id          INTEGER         NOT NULL
                                      REFERENCES Training.Workouts (id)
                                      ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Training.WorkoutSet
(
  id                  SERIAL          PRIMARY KEY,
  workoutexercise_id  INTEGER         NOT NULL
                                      REFERENCES Training.WorkoutExercises (id)
                                      ON DELETE CASCADE,
  reps                INTEGER         NOT NULL,
  weight              NUMERIC(6,2)
);
