module LiftMe.Authentication.Routing where

import Control.Monad

import Database.HDBC
import Happstack.Server

-- local imports
import LiftMe.Database
import Util.Types

authRoute :: DB -> ServerPartT IO ApiResult
authRoute con = mzero
