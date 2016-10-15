module Main where

import Control.Monad
import Happstack.Server.SimpleHTTP

-- Routing
import LiftMe.Routing.Main (mainRoute, PathConfiguration(..))

-- Local path configuration
pathConfiguration = PathConfiguration
  { staticFilesFilePath = "static"
  }

-- HTTP server configuration
serverConf = nullConf
  { port = 8080
  , logAccess = Just logMAccess
  }

-- Run the webserver
main :: IO ()
main = simpleHTTP serverConf $ do
  -- Only allow connections from localhost => nginx proxy
  guard . ("127.0.0.1" ==) . fst . rqPeer =<< askRq
  -- Run main routing
  mainRoute pathConfiguration
