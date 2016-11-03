module LiftMe.Routing where

--import Control.Applicative
import Control.Monad
import Control.Monad.Trans
import Data.Aeson
import Data.Convertible
import Database.HDBC
import Happstack.Server

-- local imports
import Util.Types
import LiftMe.Authentication.Routing
import LiftMe.Training.Routing

data PathConfiguration = PathConfiguration
  { staticFilesFilePath :: FilePath
  }

mainRoute
  :: IConnection con
  => PathConfiguration
  -> con
  -> ServerPartT IO Response
mainRoute pc con = msum
  [ dir "api" $ apiRoute con
  , staticFileServeRoute (staticFilesFilePath pc)
  ]

staticFileServeRoute
  :: FilePath     -- ^ Path to static files
  -> ServerPartT IO Response
staticFileServeRoute staticFilePath = msum
  [ dir "static" $ serveDirectory DisableBrowsing ["index.html"] staticFilePath
  , serveFile (asContentType "text/html") "static/index.html"
  ]

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
