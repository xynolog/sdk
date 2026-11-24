-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobsBudgets (JobsBudgets (..), JobsBudgetsBudgetsItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobType

data JobsBudgets = JobsBudgets
  { jobsBudgetsBudgets :: [JobsBudgetsBudgetsItem]
  }
  deriving (Eq, Show)

instance FromJSON JobsBudgets where parseJSON = checked "JobsBudgets" $ withObject "JobsBudgets" (\fields -> JobsBudgets <$> (fields .: "budgets"))

instance ToJSON JobsBudgets where toJSON value = Object (KM.fromList (concat [[("budgets", toJSON (jobsBudgetsBudgets value))]]))

data JobsBudgetsBudgetsItem = JobsBudgetsBudgetsItem
  { jobsBudgetsBudgetsItemJobType :: JobType,
    jobsBudgetsBudgetsItemMaxRetries :: Integer
  }
  deriving (Eq, Show)

instance FromJSON JobsBudgetsBudgetsItem where parseJSON = checked "JobsBudgetsBudgetsItem" $ withObject "JobsBudgetsBudgetsItem" (\fields -> JobsBudgetsBudgetsItem <$> (fields .: "jobType") <*> (fields .: "maxRetries"))

instance ToJSON JobsBudgetsBudgetsItem where toJSON value = Object (KM.fromList (concat [[("jobType", toJSON (jobsBudgetsBudgetsItemJobType value))], [("maxRetries", toJSON (jobsBudgetsBudgetsItemMaxRetries value))]]))
