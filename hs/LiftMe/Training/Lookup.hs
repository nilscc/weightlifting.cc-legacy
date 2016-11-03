-- Flexible contexts used for Query type definition from Util.DatabaseHelper
{-# LANGUAGE FlexibleContexts #-}

{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module LiftMe.Training.Lookup where

import Control.Monad
import Control.Monad.Trans

import Data.Convertible
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text

-- frameworks
import Database.HDBC

-- local imports
import Util.DatabaseHelper
import qualified LiftMe.Training.DatabaseTypes as DB
import qualified LiftMe.Training.ApiTypes      as API


lookupWorkouts :: Query [ API.Workout ]
lookupWorkouts con = do

  -- Fetch all workouts
  workouts <- fetchAllConv con "select * from training.workouts" []

  -- Lookup exercises for workout
  forM workouts $ \w -> do
    ex <- lookupWorkoutExercises w
    return $ API.Workout (DB.workoutId w) (DB.workoutDate w) ex

 where
  lookupWorkoutExercises (DB.Workout id' userId date) = do
    exercises <- fetchAllConv con
      "select * from training.workoutexercises where workout_id = ?"
      [toSql id']

    forM exercises $ \e -> do
      name <- lookupExerciseName e
      sets :: [DB.WorkoutSet] <- lookupWorkoutSets e
      return $ API.WorkoutExercise id' name (map convert sets)

  lookupExerciseName w = do
    all <- fetchAllSql con
      "select name from training.exercises where id = ?"
      [toSql $ DB.workoutExerciseExerciseId w]
    case all of
      [[SqlByteString name]] -> return $ Text.decodeUtf8 name
      s -> error "Unknown exercise ID"

  lookupWorkoutSets w = do
    fetchAllConv con
      "select id, reps, weight from training.workoutsets where workoutexercise_id = ?"
      [toSql $ DB.workoutExerciseWorkoutId w]
