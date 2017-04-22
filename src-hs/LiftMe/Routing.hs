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
import LiftMe.Authentication.Routing
import LiftMe.Training.Routing

import LiftMe.Html.MainPage
import LiftMe.Html.Error.NotFound
import LiftMe.Html.Menu

data PathConfiguration = PathConfiguration
  { staticFilesFilePath :: FilePath
  }

mainRoute
  :: IConnection con
  => PathConfiguration
  -> con
  -> ServerPartT IO Response
mainRoute pc con = msum
  [ dir "api"    $ apiRoute con
  , dir "static" $ staticFileServeRoute (staticFilesFilePath pc)
  , notFoundRoute
  ]

staticFileServeRoute
  :: FilePath     -- ^ Path to static files
  -> ServerPartT IO Response
staticFileServeRoute staticFilePath = do
  -- lookup any files under the explicit 'static' directory
  serveDirectory DisableBrowsing ["index.html"] staticFilePath

apiRoute
  :: IConnection con
  => con
  -> ServerPartT IO Response
apiRoute con = do

  apiResult <- msum
    [ dir "auth"     $ authRoute con
    , dir "training" $ trainingRoute con
    ]

  case apiResult of
    ApiOk val    -> ok $ toResponse $ encode val
    ApiError err -> badRequest $ toResponse err

notFoundRoute :: ServerPart Response
notFoundRoute = notFound $ toResponse notFoundPage
