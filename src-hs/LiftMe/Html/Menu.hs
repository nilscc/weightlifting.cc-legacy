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

data MenuText = MenuText
  { mt_hello :: Text
  }

data Menu = Menu
  { userName    :: Text
  , userPicture :: Maybe Text
  , userProfile :: Text
  }

instance ToMarkup (MenuText, Menu) where
  toMarkup (txt, menu) = do

    -- show profile picture (if any)
    case userPicture menu of
      Nothing  -> return ()
      Just pic -> H.img ! H.src (H.toValue pic)

    -- user greeting & link to profile
    H.a ! H.href (H.toValue $ userProfile menu) $ do
      H.toHtml (mt_hello txt)
      " "
      H.toHtml (userName menu)
