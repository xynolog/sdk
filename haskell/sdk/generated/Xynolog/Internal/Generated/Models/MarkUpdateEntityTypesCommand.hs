-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkUpdateEntityTypesCommand (MarkUpdateEntityTypesCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkUpdateEntityTypesCommand = MarkUpdateEntityTypesCommand
  { markUpdateEntityTypesCommandResourceId :: ResourceId,
    markUpdateEntityTypesCommandUserId :: Maybe UserId,
    markUpdateEntityTypesCommandCurrentEntityTypes :: [Text],
    markUpdateEntityTypesCommandUpdatedEntityTypes :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON MarkUpdateEntityTypesCommand where parseJSON = checked "MarkUpdateEntityTypesCommand" $ withObject "MarkUpdateEntityTypesCommand" (\fields -> MarkUpdateEntityTypesCommand <$> (fields .: "resourceId") <*> optional fields "_userId" <*> (fields .: "currentEntityTypes") <*> (fields .: "updatedEntityTypes"))

instance ToJSON MarkUpdateEntityTypesCommand where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (markUpdateEntityTypesCommandResourceId value))], optionalPair "_userId" (markUpdateEntityTypesCommandUserId value), [("currentEntityTypes", toJSON (markUpdateEntityTypesCommandCurrentEntityTypes value))], [("updatedEntityTypes", toJSON (markUpdateEntityTypesCommandUpdatedEntityTypes value))]]))
