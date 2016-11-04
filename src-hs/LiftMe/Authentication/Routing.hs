module LiftMe.Authentication.Routing where

import Control.Monad

import Database.HDBC
import Happstack.Server

-- local imports
import Util.Types

authRoute :: IConnection con => con -> ServerPartT IO ApiResult
authRoute con = mzero
