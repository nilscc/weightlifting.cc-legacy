-- derive generic types for Aeson
{-# LANGUAGE DeriveGeneric #-}

{-# LANGUAGE MultiParamTypeClasses #-}

module LiftMe.Training.ApiTypes where

import Data.Aeson
import Data.Convertible
import Data.Time
import qualified Data.Text as Text

-- GHC specific imports
import GHC.Generics

-- local imports
import qualified LiftMe.Training.DatabaseTypes as DB

data Workout = Workout
  { workoutId :: DB.Id
  , workoutDate :: LocalTime
  , workoutExercises :: [WorkoutExercise]
  }
  deriving Generic

instance ToJSON Workout where
  toEncoding = genericToEncoding defaultOptions

data WorkoutExercise = WorkoutExercise
  { workoutExerciseId :: DB.Id
  , workoutExerciseName :: Text.Text
  , workoutExerciseSets :: [WorkoutSet]
  }
  deriving Generic

instance ToJSON WorkoutExercise where
  toEncoding = genericToEncoding defaultOptions

data WorkoutSet = WorkoutSet
  { workoutSetId :: DB.Id
  , workoutSetReps :: Integer
  , workoutSetWeight :: Rational
  }
  deriving Generic

instance ToJSON WorkoutSet where
  toEncoding = genericToEncoding defaultOptions

instance Convertible DB.WorkoutSet WorkoutSet where
  safeConvert (DB.WorkoutSet id' reps weight) = Right $
    WorkoutSet id' reps weight
