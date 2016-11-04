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
import LiftMe.Training.Lookup

type ApiRoute = forall con. IConnection con => con -> ServerPartT IO ApiResult

trainingRoute :: ApiRoute
trainingRoute con = msum
  [ dir "workouts" $ workoutRoute con
  ]

workoutRoute :: ApiRoute
workoutRoute con = do
  apiOk <$> lookupWorkouts con
