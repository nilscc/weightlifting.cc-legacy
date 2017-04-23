{-# LANGUAGE OverloadedStrings #-}

module LiftMe.Html.Content where

import LiftMe.Database

import Happstack.Server
import Text.Blaze.Html5 (Html)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

getContent :: DB -> ServerPart Html
getContent db = return $ do
  H.h1 "Main content."
  H.p "bla bla bla"
