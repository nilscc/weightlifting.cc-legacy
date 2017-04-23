{-# LANGUAGE RankNTypes #-}

module LiftMe.Database.DB
  ( DB
  , connection
  , withDB
  ) where

import Data.Text (Text)
import qualified Data.Text as T

import qualified Database.HDBC as HDBC
import qualified Database.HDBC.PostgreSQL as PG

data DB = DB
  { m_con :: PG.Connection
  }

-- | Get PostgreSQL connection
connection :: DB -> PG.Connection
connection = m_con

-- | Connect to a PostgreSQL server and automatically disconnect if the
-- handler exits normally or throws an exception
withDB
  :: String -- PostgreSQL connection string
  -> (DB -> IO a)
  -> IO a
withDB conStr action = PG.withPostgreSQL conStr $ \con -> action (DB con)

--------------------------------------------------------------------------------
-- Queries
