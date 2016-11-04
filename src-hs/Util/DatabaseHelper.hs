{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleContexts #-}

module Util.DatabaseHelper where

import Data.Aeson
import Data.Convertible
import Database.HDBC
import Control.Monad.Trans

type Query a = forall m con. (MonadIO m, IConnection con, ToJSON a) => con -> m a

fetchAllSql
  :: (MonadIO m, IConnection con)
  => con          -- ^ Database connection
  -> String       -- ^ Database query string
  -> [SqlValue]   -- ^ Query positional parameters
  -> m [[SqlValue]]
fetchAllSql con qry para = liftIO $ do
  stmt <- prepare con qry
  execute stmt para
  fetchAllRows stmt

fetchAllConv
  :: (MonadIO m, IConnection con, Convertible [SqlValue] a)
  => con          -- ^ Database connection
  -> String       -- ^ Database query string
  -> [SqlValue]   -- ^ Query positional parameters
  -> m [a]
fetchAllConv con qry para = do
  rows <- fetchAllSql con qry para
  return [ convert x | x <- rows ]
