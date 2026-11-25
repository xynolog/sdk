-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WeaveApplied (WeaveApplied (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data WeaveApplied = WeaveApplied
  { weaveAppliedResourceId :: ResourceId,
    weaveAppliedSequenceNumber :: Integer
  }
  deriving (Eq, Show)

instance FromJSON WeaveApplied where parseJSON = checked "WeaveApplied" $ withObject "WeaveApplied" (\fields -> WeaveApplied <$> (fields .: "resourceId") <*> (fields .: "sequenceNumber"))

instance ToJSON WeaveApplied where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (weaveAppliedResourceId value))], [("sequenceNumber", toJSON (weaveAppliedSequenceNumber value))]]))
