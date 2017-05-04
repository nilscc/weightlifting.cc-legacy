{-# LANGUAGE FlexibleContexts #-}

-- Rank N types are used for ApiRoute typedef
{-# LANGUAGE RankNTypes #-}

module LiftMe.Training.Routing where

import Control.Applicative
import Control.Monad
import Control.Monad.Trans

-- Aeson
import Data.Aeson

-- HDBC
import Database.HDBC (IConnection)

-- Happstack
import Happstack.Server

-- local imports
import Util.DatabaseHelper
import Util.Types
import LiftMe.Database

import qualified LiftMe.Training.ApiTypes as API

newWorkoutRoute :: DB -> ServerPart Response
newWorkoutRoute db = do
  
  -- require POST method
  method POST

  msum [ validWorkoutRoute
       , invalidWorkoutRoute
       ]
 where
  validWorkoutRoute = do
    Just workout <- decode <$> lookBS "workout"
    guard $ validWorkout workout
    addWorkout workout

  invalidWorkoutRoute = do
    badRequest $ toResponse "Invalid workout."

  -- check if workout input is valid
  validWorkout w = not $ null (API.workoutExercises w)

  -- add workout to DB and return its HTML representation
  addWorkout w = do

    let userId    = 1 -- TODO: Lookup proper user ID of current session
        date      = API.workoutDate w
        exercises = API.workoutExercises w

    -- create new workout
    Just dbWorkout <- liftIO $ newWorkout db userId date

    -- add exercises to workout
    forM_ exercises $ \exercise -> do

      let name = API.workoutExerciseName exercise
          sets = API.workoutExerciseSets exercise

      Just dbExercise <- liftIO $ addWorkoutExercise db dbWorkout name

      forM_ sets $ \set -> do

        let weight = API.workoutSetWeight set
            reps   = API.workoutSetReps   set

        True <- liftIO $ addWorkoutSet db dbExercise weight reps
        return ()

    -- not implemented
    ok $ toResponse "Workout added."
