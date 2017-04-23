{-# LANGUAGE OverloadedStrings #-}

module LiftMe.Html.Footer where

import LiftMe.Database

import Happstack.Server
import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

getFooter :: DB -> ServerPart Html
getFooter db = return $
  H.p $ do
    "Copyright 2017 by "
    H.a ! A.href "https://nils.cc" $ "nils.cc"
    ". All rights reserved."
