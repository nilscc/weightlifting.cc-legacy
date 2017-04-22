{-# LANGUAGE NamedFieldPuns #-}

module Util.Html where

import Data.Text (Text)

import           Text.Blaze.Html5 (Html, ToMarkup, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as H

data Link = Link
  { target  :: Text
  , caption :: Text
  }

instance ToMarkup Link where
  toMarkup Link{ target, caption } = H.a ! H.href (H.toValue target) $ H.toHtml caption
