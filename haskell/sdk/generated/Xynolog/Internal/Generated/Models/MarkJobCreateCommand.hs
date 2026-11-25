-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobCreateCommand (MarkJobCreateCommand (..), MarkJobCreateCommandJobType (..), markJobCreateCommandJobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkJobParams
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkJobCreateCommand = MarkJobCreateCommand
  { markJobCreateCommandUserId :: Maybe UserId,
    markJobCreateCommandRoles :: Maybe [Text],
    markJobCreateCommandJobType :: MarkJobCreateCommandJobType,
    markJobCreateCommandResourceId :: ResourceId,
    markJobCreateCommandParams :: MarkJobParams
  }
  deriving (Eq, Show)

instance FromJSON MarkJobCreateCommand where parseJSON = checked "MarkJobCreateCommand" $ withObject "MarkJobCreateCommand" (\fields -> MarkJobCreateCommand <$> optional fields "_userId" <*> optional fields "_roles" <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> (fields .: "params"))

instance ToJSON MarkJobCreateCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markJobCreateCommandUserId value), optionalPair "_roles" (markJobCreateCommandRoles value), [("jobType", toJSON (markJobCreateCommandJobType value))], [("resourceId", toJSON (markJobCreateCommandResourceId value))], [("params", toJSON (markJobCreateCommandParams value))]]))

data MarkJobCreateCommandJobType = MarkJobCreateCommandJobTypeMark deriving (Eq, Show)

instance FromJSON MarkJobCreateCommandJobType where parseJSON = checked "MarkJobCreateCommandJobType" $ \value -> if value == String "mark" then pure MarkJobCreateCommandJobTypeMark else fail "unknown enumeration member"

instance ToJSON MarkJobCreateCommandJobType where toJSON MarkJobCreateCommandJobTypeMark = String "mark"

markJobCreateCommandJobTypeText :: MarkJobCreateCommandJobType -> Text
markJobCreateCommandJobTypeText MarkJobCreateCommandJobTypeMark = "mark"
