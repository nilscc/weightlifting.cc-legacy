{-# LANGUAGE NamedFieldPuns #-}

module LiftMe.Database.Training where

import Data.Time
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

type UserId = Integer
newtype Workout = Workout { m_workoutId :: Integer }

newWorkout :: DB -> UserId -> LocalTime -> IO (Maybe Workout)
newWorkout db userId date = do

  -- add workout to database
  stmt <- HDBC.prepare (connection db)
    "INSERT INTO Training.Workouts (user_id, date) VALUES (?, ?) RETURNING id"
  mod <- HDBC.execute stmt
    [ HDBC.toSql userId
    , HDBC.toSql date
    ]
  
  -- check if the insert was successful
  if mod /= 1
    then return Nothing
    else do
      -- look up RETURNING value (workout id)
      row <- HDBC.fetchRow stmt
      case row of
        Just [ HDBC.SqlInteger i ] -> return $ Just $ Workout i
        _ -> return Nothing

newtype WorkoutExercise = WorkoutExercise { m_workoutExerciseId :: Integer }

addWorkoutExercise :: DB -> Workout -> Text -> IO (Maybe WorkoutExercise)
addWorkoutExercise db workout exerciseName = do
  undefined

addWorkoutSet
  :: DB
  -> WorkoutExercise
  -> Rational           -- ^ Weight
  -> Integer            -- ^ Reps
  -> IO Bool
addWorkoutSet db workoutExercise weight reps = do
  undefined
