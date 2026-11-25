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
  { listResourcesResponseResources :: [ResourceDescriptor],
    listResourcesResponseTotal :: Scientific,
    listResourcesResponseOffset :: Scientific,
    listResourcesResponseLimit :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON ListResourcesResponse where parseJSON = checked "ListResourcesResponse" $ withObject "ListResourcesResponse" (\fields -> ListResourcesResponse <$> (fields .: "resources") <*> (fields .: "total") <*> (fields .: "offset") <*> (fields .: "limit"))

instance ToJSON ListResourcesResponse where toJSON value = Object (KM.fromList (concat [[("resources", toJSON (listResourcesResponseResources value))], [("total", toJSON (listResourcesResponseTotal value))], [("offset", toJSON (listResourcesResponseOffset value))], [("limit", toJSON (listResourcesResponseLimit value))]]))
