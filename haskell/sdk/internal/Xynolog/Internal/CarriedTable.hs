module Xynolog.Internal.CarriedTable (carriedTable) where

import Data.Aeson (FromJSON, Result (..), Value, fromJSON)

-- | A carried table's rows as its schema's type, read by that type's own
-- reader. Rows the reader refuses are the generator's fault, so reading them
-- is an error, not a value: the suite's tableCases reads every table.
carriedTable :: (FromJSON table) => String -> Value -> table
carriedTable file rows = case fromJSON rows of
  Success table -> table
  Error problem -> error (file ++ " is not what its schema's type reads: " ++ problem)
