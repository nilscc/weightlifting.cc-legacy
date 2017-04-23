-- {-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}

module LiftMe.Html.Error.NotFound where

import Data.Text (Text)
import qualified Data.Text as T

import           Text.Blaze.Html5 (Html, ToMarkup, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import LiftMe.Html.MainPage
import LiftMe.Html.Menu

notFoundPage :: MainPage
notFoundPage = defaultMainPage menu content footer
 where
  menu = return ()
  content = do
    H.h1 "404: Page not found"
    H.p  "The requested page was not found."
  footer = return ()
