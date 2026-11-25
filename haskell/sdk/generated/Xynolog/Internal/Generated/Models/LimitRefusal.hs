-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LimitRefusal (LimitRefusal (..), LimitRefusalCode (..), limitRefusalCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data LimitRefusal = LimitRefusal
  { limitRefusalError :: Text,
    limitRefusalCode :: LimitRefusalCode,
    limitRefusalHint :: Maybe Text,
    limitRefusalDetails :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON LimitRefusal where parseJSON = checked "LimitRefusal" $ withObject "LimitRefusal" (\fields -> LimitRefusal <$> (fields .: "error") <*> (fields .: "code") <*> optional fields "hint" <*> optional fields "details")

instance ToJSON LimitRefusal where toJSON value = Object (KM.fromList (concat [[("error", toJSON (limitRefusalError value))], [("code", toJSON (limitRefusalCode value))], optionalPair "hint" (limitRefusalHint value), optionalPair "details" (limitRefusalDetails value)]))

data LimitRefusalCode = LimitRefusalCodeStreams | LimitRefusalCodeEmitRate | LimitRefusalCodeUnansweredRequests | LimitRefusalCodeCapacity | LimitRefusalCodeRefusalRate deriving (Eq, Show)

instance FromJSON LimitRefusalCode where parseJSON = checked "LimitRefusalCode" $ \value -> if value == String "streams" then pure LimitRefusalCodeStreams else if value == String "emit-rate" then pure LimitRefusalCodeEmitRate else if value == String "unanswered-requests" then pure LimitRefusalCodeUnansweredRequests else if value == String "capacity" then pure LimitRefusalCodeCapacity else if value == String "refusal-rate" then pure LimitRefusalCodeRefusalRate else fail "unknown enumeration member"

instance ToJSON LimitRefusalCode where
  toJSON LimitRefusalCodeStreams = String "streams"
  toJSON LimitRefusalCodeEmitRate = String "emit-rate"
  toJSON LimitRefusalCodeUnansweredRequests = String "unanswered-requests"
  toJSON LimitRefusalCodeCapacity = String "capacity"
  toJSON LimitRefusalCodeRefusalRate = String "refusal-rate"

limitRefusalCodeText :: LimitRefusalCode -> Text
limitRefusalCodeText LimitRefusalCodeStreams = "streams"
limitRefusalCodeText LimitRefusalCodeEmitRate = "emit-rate"
limitRefusalCodeText LimitRefusalCodeUnansweredRequests = "unanswered-requests"
limitRefusalCodeText LimitRefusalCodeCapacity = "capacity"
limitRefusalCodeText LimitRefusalCodeRefusalRate = "refusal-rate"
