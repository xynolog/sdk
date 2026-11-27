-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FrameRefusal (FrameRefusal (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FrameRefusalReason
import Xynolog.Internal.Generated.Models.ResourceId

data FrameRefusal = FrameRefusal
  { frameRefusalChannel :: Text,
    frameRefusalMember :: Text,
    frameRefusalReason :: FrameRefusalReason,
    frameRefusalPayload :: Maybe Value,
    frameRefusalScope :: Maybe ResourceId,
    frameRefusalCorrelationId :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON FrameRefusal where parseJSON = checked "FrameRefusal" $ withObject "FrameRefusal" (\fields -> FrameRefusal <$> (fields .: "channel") <*> (fields .: "member") <*> (fields .: "reason") <*> optional fields "payload" <*> optional fields "scope" <*> optional fields "correlationId")

instance ToJSON FrameRefusal where toJSON value = Object (KM.fromList (concat [[("channel", toJSON (frameRefusalChannel value))], [("member", toJSON (frameRefusalMember value))], [("reason", toJSON (frameRefusalReason value))], optionalPair "payload" (frameRefusalPayload value), optionalPair "scope" (frameRefusalScope value), optionalPair "correlationId" (frameRefusalCorrelationId value)]))
