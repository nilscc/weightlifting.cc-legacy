{-# LANGUAGE OverloadedStrings #-}

module LiftMe.Html.Content where

import Control.Monad
import Control.Monad.Trans

import Happstack.Server
import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import LiftMe.Database

getContent :: DB -> ServerPart Html
getContent db = do

  -- get list of exercises from database
  exs <- liftIO $ do
    cats <- categories db
    forM cats $ \cat -> do
      exs <- exercises db cat
      return (cat, exs)

  return $ do
    H.h1 "Exercises"

    forM_ exs $ \(cat, exs) -> do
      H.h2 $ H.toHtml (m_categoryName cat)
      H.ul ! A.id (H.toValue $ "category_" ++ show (m_categoryId cat)) $ do
        forM_ exs $ \ex -> do
          H.li ! A.id (H.toValue $ "exercise_" ++ show (m_exerciseId ex)) $
            H.toHtml (m_exerciseName ex)
