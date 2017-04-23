{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Happstack.Server.SimpleHTTP
import Database.HDBC.PostgreSQL

import qualified Data.Text as T
import qualified Data.Text.IO as T

import LiftMe.Database

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
postgresConf = "host='localhost' user='weightlifting-cc' dbname='weightlifting-cc-dev' password='1234'"

-- Run the webserver
main :: IO ()
main = do
  withDB postgresConf $ \db -> do
    putStrLn $ "Starting HTTP server on port " ++ show (port serverConf) ++ "."
    simpleHTTP serverConf $ do
      -- Only allow connections from localhost => nginx proxy
      guard . ("127.0.0.1" ==) . fst . rqPeer =<< askRq
      -- Run main routing
      mainRoute pathConfiguration db
