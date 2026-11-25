-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherResourceComplete (GatherResourceComplete (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GatheredContext
import Xynolog.Internal.Generated.Models.ResourceId

data GatherResourceComplete = GatherResourceComplete
  { gatherResourceCompleteResourceId :: ResourceId,
    gatherResourceCompleteResponse :: GatheredContext
  }
  deriving (Eq, Show)

instance FromJSON GatherResourceComplete where parseJSON = checked "GatherResourceComplete" $ withObject "GatherResourceComplete" (\fields -> GatherResourceComplete <$> (fields .: "resourceId") <*> (fields .: "response"))

instance ToJSON GatherResourceComplete where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (gatherResourceCompleteResourceId value))], [("response", toJSON (gatherResourceCompleteResponse value))]]))
