{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}

module LiftMe.Html.MainPage where

import Control.Monad
import Data.Text (Text)
import qualified Data.Text as T

import Happstack.Server

import           Text.Blaze.Html5 (Html, ToMarkup, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

--
-- Stylesheets
--

data Stylesheet
  = LinkStylesheet   { linkStylesheet   :: Text }
  | InlineStylesheet { inlineStylesheet :: Text }

-- render as HTML
instance ToMarkup Stylesheet where
  toMarkup (LinkStylesheet lnk) =
    H.link ! A.href (H.toValue $ "/static/" `T.append` lnk) ! A.rel "stylesheet" ! A.type_ "text/css"
  toMarkup (InlineStylesheet inl) =
    H.style ! A.type_ "text/css" $ H.toHtml inl

--
-- JavaScript
--

data Javascript
  = LinkJavascript   { linkJavascript   :: Text, linkJavascriptDataTags :: [(H.Tag, Text)] }
  | InlineJavaScript { inlineJavascript :: Text }

-- render as HTML
instance ToMarkup Javascript where
  toMarkup (LinkJavascript lnk tags) =
    let s = H.script ! A.src (H.toValue $ "/static/" `T.append` lnk) ! A.type_ "text/javascript"
     in foldr (\(t,v) s' -> s' ! H.dataAttribute t (H.toValue v)) s tags $ return ()
  toMarkup (InlineJavaScript inl) =
    H.script ! A.type_ "text/javascript" $ H.toHtml inl

--
-- The main content page
--

data MainPage = MainPage
  { css     :: [Stylesheet]
  , js      :: [Javascript]
  , menu    :: Html
  , content :: Html
  , footer  :: Html
  }

-- render page as HTML
instance ToMarkup MainPage where
  toMarkup MainPage{ menu, content, footer, css, js } =
    H.docTypeHtml $ do
      H.head $ do
        H.meta ! A.charset "UTF-8"

        -- load CSS & JavaScript
        mapM_ H.toMarkup css
        mapM_ H.toMarkup js

      H.body $ do
        H.menu   $ menu
        H.main   $ content
        H.footer $ footer

-- Happsack Message instance
instance ToMessage MainPage where
  toContentType _ = toContentType H.docType
  toMessage       = toMessage . H.toMarkup

emptyMainPage :: MainPage
emptyMainPage = MainPage
  { css     = []
  , js      = []
  , menu    = return ()
  , content = return ()
  , footer  = return ()
  }

defaultMainPage :: MainPage
defaultMainPage = emptyMainPage
  { css = [ LinkStylesheet "style/main.css" ]
  , js  = [ LinkJavascript "js/require.js" [("main", "/static/js/require.config.js")] ]
  }
