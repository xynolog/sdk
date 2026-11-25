-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldCloneTokenRequest (YieldCloneTokenRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data YieldCloneTokenRequest = YieldCloneTokenRequest
  { yieldCloneTokenRequestResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON YieldCloneTokenRequest where parseJSON = checked "YieldCloneTokenRequest" $ withObject "YieldCloneTokenRequest" (\fields -> YieldCloneTokenRequest <$> (fields .: "resourceId"))

instance ToJSON YieldCloneTokenRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (yieldCloneTokenRequestResourceId value))]]))
