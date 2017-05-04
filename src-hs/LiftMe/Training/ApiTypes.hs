-- derive generic types for Aeson
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE MultiParamTypeClasses #-}

module LiftMe.Training.ApiTypes where

import Data.Aeson
import Data.Aeson.Types (typeMismatch)

import Data.Convertible
import Data.Time
import qualified Data.Text as Text
import Data.Typeable

-- GHC specific imports
import GHC.Generics

-- HDBC
import Database.HDBC


unexpected :: (Show a, Typeable a, Typeable b) => a -> ConvertResult b
unexpected = convError "Unexpected SQL value"

--------------------------------------------------------------------------------
-- Workout types

data Workout = Workout
  { workoutDate :: LocalTime
  , workoutExercises :: [WorkoutExercise]
  }
  deriving Generic

instance FromJSON Workout where
  parseJSON (Object o) = Workout <$> o .: "date" <*> o .: "exercises"
  parseJSON invalid    = typeMismatch "Workout" invalid

data WorkoutExercise = WorkoutExercise
  { workoutExerciseName :: Text.Text
  , workoutExerciseSets :: [WorkoutSet]
  }
  deriving Generic

instance FromJSON WorkoutExercise where
  parseJSON (Object o) = WorkoutExercise <$> o .: "name" <*> o .: "sets"
  parseJSON invalid    = typeMismatch "WorkoutExercise" invalid

data WorkoutSet = WorkoutSet
  { workoutSetReps :: Integer
  , workoutSetWeight :: Rational
  }
  deriving Generic

instance FromJSON WorkoutSet where
  parseJSON (Object o) = WorkoutSet <$> o .: "reps" <*> o .: "weight"
  parseJSON invalid    = typeMismatch "WorkoutSet" invalid
