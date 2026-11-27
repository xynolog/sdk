-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherResourceFailed (GatherResourceFailed (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ArchivistMessages
import Xynolog.Internal.Generated.Models.ResourceId

data GatherResourceFailed = GatherResourceFailed
  { gatherResourceFailedCode :: Maybe CommandErrorCode,
    gatherResourceFailedMessage :: Text,
    gatherResourceFailedDetails :: Maybe Text,
    gatherResourceFailedResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON GatherResourceFailed where parseJSON = checked "GatherResourceFailed" $ withObject "GatherResourceFailed" (\fields -> GatherResourceFailed <$> optional fields "code" <*> (fields .: "message") <*> optional fields "details" <*> (fields .: "resourceId"))

instance ToJSON GatherResourceFailed where toJSON value = Object (KM.fromList (concat [optionalPair "code" (gatherResourceFailedCode value), [("message", toJSON (gatherResourceFailedMessage value))], optionalPair "details" (gatherResourceFailedDetails value), [("resourceId", toJSON (gatherResourceFailedResourceId value))]]))
