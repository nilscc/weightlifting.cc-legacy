module LiftMe.Routing.Main where

import Happstack.Server

data PathConfiguration = PathConfiguration
  { staticFilesFilePath :: FilePath
  }

mainRoute :: PathConfiguration -> ServerPartT IO Response
mainRoute pc = do
  staticFileServeRoute (staticFilesFilePath pc)

staticFileServeRoute
  :: FilePath     -- ^ Path to static files
  -> ServerPartT IO Response
staticFileServeRoute staticFilePath = do
  serveDirectory DisableBrowsing ["index.html"] staticFilePath
