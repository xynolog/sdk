-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Cancelled (Cancelled (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RequestId

data Cancelled = Cancelled
  { cancelledReason :: Maybe Text,
    cancelledRequestId :: RequestId
  }
  deriving (Eq, Show)

instance FromJSON Cancelled where parseJSON = checked "Cancelled" $ withObject "Cancelled" (\fields -> Cancelled <$> optional fields "reason" <*> (fields .: "requestId"))

instance ToJSON Cancelled where toJSON value = Object (KM.fromList (concat [optionalPair "reason" (cancelledReason value), [("requestId", toJSON (cancelledRequestId value))]]))
