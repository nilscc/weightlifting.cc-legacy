{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module LiftMe.Html.Menu where

import Data.Text (Text)

import Happstack.Server

import           Text.Blaze.Html5 (Html, ToMarkup, (!))
import qualified Text.Blaze.Html5            as H
import qualified Text.Blaze.Html5.Attributes as H

import Util.Html

import LiftMe.Database

data MenuText = MenuText
  { mt_notRegistered :: Text
  }

defaultMenuText :: MenuText
defaultMenuText = MenuText
  { mt_notRegistered = "Not registered."
  }

data Menu = NotRegisteredMenu

instance ToMarkup (MenuText, Menu) where
  toMarkup (txt, menu) = do

    H.p $ H.toHtml (mt_notRegistered txt)

getMenu :: DB -> ServerPart Html
getMenu db = do

  let menuText = defaultMenuText
      menu     = NotRegisteredMenu

  return $ H.toMarkup (menuText, menu)
