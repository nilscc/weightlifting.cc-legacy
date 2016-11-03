{-# LANGUAGE FlexibleContexts #-}

module LiftMe.Training.Routing where

import Control.Applicative
import Control.Monad
import Control.Monad.Trans

import Data.Aeson
import Data.Convertible

import Database.HDBC
import Happstack.Server

-- local imports
import Util.DatabaseHelper
import Util.Types
import LiftMe.Training.DatabaseTypes

trainingRoute :: IConnection con => con -> ServerPartT IO ApiResult
trainingRoute con = msum
  [ dir "workouts" $ apiOk <$> workoutRoute con
  ]

workoutRoute :: Query (ServerPartT IO) [WorkoutSet]
workoutRoute con = do
  allRows <- liftIO $ do
    stmt <- prepare con "select id, reps, weight from training.workoutset"
    execute stmt []
    fetchAllRows stmt
  return [ convert x :: WorkoutSet | x <- allRows ]
