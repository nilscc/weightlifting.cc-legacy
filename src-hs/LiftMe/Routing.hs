module LiftMe.Routing where

--import Control.Applicative
import Control.Monad
import Control.Monad.Trans

import Data.Aeson
import Data.Convertible

import System.FilePath

-- frameworks
import Database.HDBC
import Happstack.Server

-- local imports
import Util.Types
import LiftMe.Database
--import LiftMe.Authentication.Routing
--import LiftMe.Training.Routing

import LiftMe.Html.MainPage
import LiftMe.Html.Error.NotFound
import LiftMe.Html.Menu
import LiftMe.Html.Content
import LiftMe.Html.Footer

import qualified LiftMe.Training.Routing as Training

data PathConfiguration = PathConfiguration
  { staticFilesFilePath :: FilePath
  }

mainRoute
  :: PathConfiguration
  -> DB
  -> ServerPartT IO Response
mainRoute pc db = msum
  [ dir "api"    $ apiRoute db
  , dir "static" $ staticFileServeRoute (staticFilesFilePath pc)
  , contentRoute db
  , notFoundRoute
  ]

staticFileServeRoute
  :: FilePath     -- ^ Path to static files
  -> ServerPartT IO Response
staticFileServeRoute staticFilePath = do
  -- lookup any files under the explicit 'static' directory
  serveDirectory DisableBrowsing ["index.html"] staticFilePath

apiRoute
  :: DB
  -> ServerPartT IO Response
apiRoute db = msum
  [ dir "new_workout" $ Training.newWorkoutRoute db
  ]

notFoundRoute :: ServerPart Response
notFoundRoute = notFound $ toResponse notFoundPage

contentRoute :: DB -> ServerPart Response
contentRoute db = do

  -- default page
  method GET
  nullDir

  -- get html content
  menu    <- getMenu    db
  content <- getContent db
  footer  <- getFooter  db

  -- build response
  ok . toResponse $ defaultMainPage menu content footer
