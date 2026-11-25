-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherResourceRequest (GatherResourceRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GatherResourceRequestOptions
import Xynolog.Internal.Generated.Models.ResourceId

data GatherResourceRequest = GatherResourceRequest
  { gatherResourceRequestResourceId :: ResourceId,
    gatherResourceRequestOptions :: GatherResourceRequestOptions
  }
  deriving (Eq, Show)

instance FromJSON GatherResourceRequest where parseJSON = checked "GatherResourceRequest" $ withObject "GatherResourceRequest" (\fields -> GatherResourceRequest <$> (fields .: "resourceId") <*> (fields .: "options"))

instance ToJSON GatherResourceRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (gatherResourceRequestResourceId value))], [("options", toJSON (gatherResourceRequestOptions value))]]))
