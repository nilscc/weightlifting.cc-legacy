module Main where

import Control.Monad
import Happstack.Server.SimpleHTTP
import Database.HDBC.PostgreSQL

-- Routing
import LiftMe.Routing (mainRoute, PathConfiguration(..))

-- Local path configuration
pathConfiguration = PathConfiguration
  { staticFilesFilePath = "static"
  }

-- HTTP server configuration
serverConf = nullConf
  { port = 8080
  , logAccess = Just logMAccess
  }

-- PostgreSQL configuration string
postgresConf = "host = 'localhost' dbname = 'liftme-test'"

-- Run the webserver
main :: IO ()
main = do
  withPostgreSQL postgresConf $ \con -> do
    simpleHTTP serverConf $ do
      -- Only allow connections from localhost => nginx proxy
      guard . ("127.0.0.1" ==) . fst . rqPeer =<< askRq
      -- Run main routing
      mainRoute pathConfiguration con
