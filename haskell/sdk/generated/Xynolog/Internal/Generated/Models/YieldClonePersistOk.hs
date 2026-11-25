-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldClonePersistOk (YieldClonePersistOk (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.YieldedResource

data YieldClonePersistOk = YieldClonePersistOk
  { yieldClonePersistOkResponse :: YieldedResource
  }
  deriving (Eq, Show)

instance FromJSON YieldClonePersistOk where parseJSON = checked "YieldClonePersistOk" $ withObject "YieldClonePersistOk" (\fields -> YieldClonePersistOk <$> (fields .: "response"))

instance ToJSON YieldClonePersistOk where toJSON value = Object (KM.fromList (concat [[("response", toJSON (yieldClonePersistOkResponse value))]]))
