-- general extensions
{-# LANGUAGE OverloadedStrings #-}

-- convertible/hdbc sql instances
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module LiftMe.Training.DatabaseTypes where

import Data.Convertible
import qualified Data.Text as Text
import Data.Time
import Data.Typeable

import Database.HDBC
import Happstack.Server.Response (ToMessage(..))

unexpected :: (Show a, Typeable a, Typeable b) => a -> ConvertResult b
unexpected = convError "Unexpected SQL value"

--------------------------------------------------------------------------------
-- General types
--

-- | IDs as represented in the postgresql database backend
type Id = Integer

--------------------------------------------------------------------------------
-- Users
--

data User = User
  { userId :: Id
  , userName :: Text.Text
  }

--------------------------------------------------------------------------------
-- Workouts
--

-- | The main workout type
data Workout = Workout
  { workoutId :: Id
  , workoutUserId :: Id
  , workoutDate :: LocalTime
  }

instance Convertible [SqlValue] Workout where
  safeConvert
    [ SqlInteger id'
    , SqlInteger user_id
    , SqlLocalTime date ]
    = Right $ Workout id' user_id date
  safeConvert sql = unexpected sql

-- | Exercises of one workout
data WorkoutExercise = WorkoutExercise
  { workoutExerciseId :: Id
  , workoutExerciseExerciseId :: Id
  , workoutExerciseWorkoutId :: Id
  }

instance Convertible [SqlValue] WorkoutExercise where
  safeConvert
    [ SqlInteger id'
    , SqlInteger exerciseId
    , SqlInteger workoutId
    ] = Right $ WorkoutExercise id' exerciseId workoutId
  safeConvert sql = unexpected sql

data WorkoutSet = WorkoutSet
  { workoutSetId :: Id
  , workoutSetReps :: Integer
  , workoutSetWeight :: Rational
  }

instance Convertible [SqlValue] WorkoutSet where
  safeConvert
    [ SqlInteger id'
    , SqlInteger reps
    , SqlRational weight ]
    = Right $ WorkoutSet id' reps weight
  safeConvert sql = unexpected sql
