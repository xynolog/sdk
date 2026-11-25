-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerAnswerFormats (WorkerAnswerFormats (..), WorkerAnswerFormatsFormatsItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data WorkerAnswerFormats = WorkerAnswerFormats
  { workerAnswerFormatsComment :: Text,
    workerAnswerFormatsFormats :: [WorkerAnswerFormatsFormatsItem]
  }
  deriving (Eq, Show)

instance FromJSON WorkerAnswerFormats where parseJSON = checked "WorkerAnswerFormats" $ withObject "WorkerAnswerFormats" (\fields -> WorkerAnswerFormats <$> (fields .: "$comment") <*> (fields .: "formats"))

instance ToJSON WorkerAnswerFormats where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (workerAnswerFormatsComment value))], [("formats", toJSON (workerAnswerFormatsFormats value))]]))

data WorkerAnswerFormatsFormatsItem = WorkerAnswerFormatsFormatsItem
  { workerAnswerFormatsFormatsItemName :: Text,
    workerAnswerFormatsFormatsItemAbout :: Text,
    workerAnswerFormatsFormatsItemElement :: Value
  }
  deriving (Eq, Show)

instance FromJSON WorkerAnswerFormatsFormatsItem where parseJSON = checked "WorkerAnswerFormatsFormatsItem" $ withObject "WorkerAnswerFormatsFormatsItem" (\fields -> WorkerAnswerFormatsFormatsItem <$> (fields .: "name") <*> (fields .: "about") <*> (fields .: "element"))

instance ToJSON WorkerAnswerFormatsFormatsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerAnswerFormatsFormatsItemName value))], [("about", toJSON (workerAnswerFormatsFormatsItemAbout value))], [("element", toJSON (workerAnswerFormatsFormatsItemElement value))]]))
