-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldCreateOk (YieldCreateOk (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.YieldedResource

data YieldCreateOk = YieldCreateOk
  { yieldCreateOkResponse :: YieldedResource
  }
  deriving (Eq, Show)

instance FromJSON YieldCreateOk where parseJSON = checked "YieldCreateOk" $ withObject "YieldCreateOk" (\fields -> YieldCreateOk <$> (fields .: "response"))

instance ToJSON YieldCreateOk where toJSON value = Object (KM.fromList (concat [[("response", toJSON (yieldCreateOkResponse value))]]))
