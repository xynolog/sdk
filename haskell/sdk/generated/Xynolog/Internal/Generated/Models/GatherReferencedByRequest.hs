-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherReferencedByRequest (GatherReferencedByRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Motivation
import Xynolog.Internal.Generated.Models.ResourceId

data GatherReferencedByRequest = GatherReferencedByRequest
  { gatherReferencedByRequestResourceId :: ResourceId,
    gatherReferencedByRequestMotivation :: Maybe Motivation
  }
  deriving (Eq, Show)

instance FromJSON GatherReferencedByRequest where parseJSON = checked "GatherReferencedByRequest" $ withObject "GatherReferencedByRequest" (\fields -> GatherReferencedByRequest <$> (fields .: "resourceId") <*> optional fields "motivation")

instance ToJSON GatherReferencedByRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (gatherReferencedByRequestResourceId value))], optionalPair "motivation" (gatherReferencedByRequestMotivation value)]))
