-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldCloneCreated (YieldCloneCreated (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.YieldedResource

data YieldCloneCreated = YieldCloneCreated
  { yieldCloneCreatedResponse :: YieldedResource
  }
  deriving (Eq, Show)

instance FromJSON YieldCloneCreated where parseJSON = checked "YieldCloneCreated" $ withObject "YieldCloneCreated" (\fields -> YieldCloneCreated <$> (fields .: "response"))

instance ToJSON YieldCloneCreated where toJSON value = Object (KM.fromList (concat [[("response", toJSON (yieldCloneCreatedResponse value))]]))
