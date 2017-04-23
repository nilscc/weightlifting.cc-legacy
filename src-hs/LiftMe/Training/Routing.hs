{-# LANGUAGE FlexibleContexts #-}

-- Rank N types are used for ApiRoute typedef
{-# LANGUAGE RankNTypes #-}

module LiftMe.Training.Routing where

import Control.Applicative
import Control.Monad
import Control.Monad.Trans

import Database.HDBC (IConnection)
import Happstack.Server

-- local imports
import Util.DatabaseHelper
import Util.Types
import LiftMe.Database
import LiftMe.Training.Lookup

type ApiRoute = DB -> ServerPartT IO ApiResult

trainingRoute :: ApiRoute
trainingRoute db = msum
  [ dir "workouts" $ workoutRoute db
  ]

workoutRoute :: ApiRoute
workoutRoute db = do
  apiOk <$> lookupWorkouts db
