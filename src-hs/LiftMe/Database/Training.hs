{-# LANGUAGE NamedFieldPuns #-}

module LiftMe.Database.Training where

import Data.Text (Text)
import qualified Data.Text.Encoding as T

import qualified Database.HDBC as HDBC

import LiftMe.Database.DB

data Category = Category
  { m_categoryId    :: Integer
  , m_categoryNr    :: Text
  , m_categoryName  :: Text
  }
  deriving (Show)

-- | Lookup training exercise cateogires
categories :: DB -> IO [Category]
categories db = do

  -- run query
  rows <- HDBC.quickQuery (connection db)
    "SELECT id, nr, name FROM data.TrainingsmittelkatalogGewichthebenBVDG_Categories"
    []

  -- convert result to haskell type
  return
    [ Category id (T.decodeUtf8 nr) (T.decodeUtf8 name)
    | [HDBC.SqlInteger id, HDBC.SqlByteString nr, HDBC.SqlByteString name] <- rows
    ]

data Exercise = Exercise
  { m_exerciseId    :: Integer
  , m_exerciseNr    :: Integer
  , m_exerciseName  :: Text
  }
  deriving (Show)

exercises :: DB -> Category -> IO [Exercise]
exercises db (Category {m_categoryId}) = do

  -- run query
  rows <- HDBC.quickQuery (connection db)
    "SELECT id, nr, name FROM data.TrainingsmittelkatalogGewichthebenBVDG WHERE grp = ?"
    [ HDBC.toSql m_categoryId ]

  -- convert result to haskell type
  return
    [ Exercise id nr (T.decodeUtf8 name)
    | [ HDBC.SqlInteger id, HDBC.SqlInteger nr, HDBC.SqlByteString name ] <- rows
    ]
