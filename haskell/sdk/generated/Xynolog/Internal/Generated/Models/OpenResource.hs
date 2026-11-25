-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OpenResource (OpenResource (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data OpenResource = OpenResource
  { openResourceId :: ResourceId,
    openResourceMediaType :: Maybe Text,
    openResourceName :: Text,
    openResourceOpenedAt :: Integer,
    openResourceOrder :: Integer,
    openResourceStorageUri :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON OpenResource where parseJSON = checked "OpenResource" $ withObject "OpenResource" (\fields -> OpenResource <$> (fields .: "id") <*> optional fields "mediaType" <*> (fields .: "name") <*> (fields .: "openedAt") <*> (fields .: "order") <*> optional fields "storageUri")

instance ToJSON OpenResource where toJSON value = Object (KM.fromList (concat [[("id", toJSON (openResourceId value))], optionalPair "mediaType" (openResourceMediaType value), [("name", toJSON (openResourceName value))], [("openedAt", toJSON (openResourceOpenedAt value))], [("order", toJSON (openResourceOrder value))], optionalPair "storageUri" (openResourceStorageUri value)]))
