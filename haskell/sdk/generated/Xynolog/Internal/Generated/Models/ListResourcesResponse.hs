-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ListResourcesResponse (ListResourcesResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceDescriptor

data ListResourcesResponse = ListResourcesResponse
  { listResourcesResponseLimit :: Scientific,
    listResourcesResponseOffset :: Scientific,
    listResourcesResponseResources :: [ResourceDescriptor],
    listResourcesResponseTotal :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON ListResourcesResponse where parseJSON = checked "ListResourcesResponse" $ withObject "ListResourcesResponse" (\fields -> ListResourcesResponse <$> (fields .: "limit") <*> (fields .: "offset") <*> (fields .: "resources") <*> (fields .: "total"))

instance ToJSON ListResourcesResponse where toJSON value = Object (KM.fromList (concat [[("limit", toJSON (listResourcesResponseLimit value))], [("offset", toJSON (listResourcesResponseOffset value))], [("resources", toJSON (listResourcesResponseResources value))], [("total", toJSON (listResourcesResponseTotal value))]]))
