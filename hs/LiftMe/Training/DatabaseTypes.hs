-- general extensions
{-# LANGUAGE OverloadedStrings #-}

-- derive generic types for Aeson
{-# LANGUAGE DeriveGeneric #-}

-- convertible/hdbc sql instances
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module LiftMe.Training.DatabaseTypes where

import GHC.Generics

import Data.Convertible
import Data.Aeson
import qualified Data.Text as Text
import Database.HDBC
import Happstack.Server.Response (ToMessage(..))

instance ToMessage Value where
  toContentType _ = "text/json"
  toMessage = encode

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

data Workout = Workout
  { workoutId :: Id
  , workoutUser :: User
  , workoutExercises :: [ WorkoutExercise ]
  }

data WorkoutExercise = WorkoutExercise
  { workoutExerciseId :: Id
  , workoutExerciseName :: Text.Text
  , workoutExerciseSets :: [ WorkoutSet ]
  }

data WorkoutSet = WorkoutSet
  { workoutSetId :: Id
  , workoutSetReps :: Integer
  , workoutSetWeight :: Rational
  }
  deriving Generic

instance Convertible [SqlValue] WorkoutSet where
  safeConvert sql = case sql of
    [ SqlInteger id',
      SqlInteger reps,
      SqlRational weight ] ->
      Right $ WorkoutSet id' reps weight
    _ -> convError "Unexpected SQL values." sql

instance ToJSON WorkoutSet where
  toEncoding = genericToEncoding defaultOptions
