{-# LANGUAGE RankNTypes #-}

module Util.DatabaseHelper where

import Data.Aeson
import Database.HDBC
import Control.Monad.Trans

type Query m a = forall con. (MonadIO m, IConnection con, ToJSON a) => con -> m a
