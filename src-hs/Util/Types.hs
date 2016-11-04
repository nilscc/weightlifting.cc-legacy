module Util.Types where

import Data.Aeson (Value, ToJSON(..))
import Data.Text (Text)

data ApiResult
  = ApiOk { value :: Value }
  | ApiError { error :: Text }

apiOk :: ToJSON a => a -> ApiResult
apiOk = ApiOk . toJSON
