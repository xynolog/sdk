module Xynolog.Internal.ServiceTable (serviceTable) where

import Data.Aeson (FromJSON, Result (..), Value, fromJSON)

-- | A service table's rows as its schema's type, read by that type's own
-- reader. Rows the reader refuses are the generator's fault, so reading them
-- is an error, not a value: the suite's serviceTableCases reads every table.
serviceTable :: (FromJSON table) => String -> Value -> table
serviceTable file rows = case fromJSON rows of
  Success table -> table
  Error problem -> error (file ++ " is not what its schema's type reads: " ++ problem)
