-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetReferencedByResponseReferencedByItem (GetReferencedByResponseReferencedByItem (..), GetReferencedByResponseReferencedByItemTarget (..), GetReferencedByResponseReferencedByItemTargetSelector (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId

data GetReferencedByResponseReferencedByItem = GetReferencedByResponseReferencedByItem
  { getReferencedByResponseReferencedByItemId :: AnnotationId,
    getReferencedByResponseReferencedByItemResourceName :: Maybe Text,
    getReferencedByResponseReferencedByItemTarget :: GetReferencedByResponseReferencedByItemTarget
  }
  deriving (Eq, Show)

instance FromJSON GetReferencedByResponseReferencedByItem where parseJSON = checked "GetReferencedByResponseReferencedByItem" $ withObject "GetReferencedByResponseReferencedByItem" (\fields -> GetReferencedByResponseReferencedByItem <$> (fields .: "id") <*> optional fields "resourceName" <*> (fields .: "target"))

instance ToJSON GetReferencedByResponseReferencedByItem where toJSON value = Object (KM.fromList (concat [[("id", toJSON (getReferencedByResponseReferencedByItemId value))], optionalPair "resourceName" (getReferencedByResponseReferencedByItemResourceName value), [("target", toJSON (getReferencedByResponseReferencedByItemTarget value))]]))

data GetReferencedByResponseReferencedByItemTarget = GetReferencedByResponseReferencedByItemTarget
  { getReferencedByResponseReferencedByItemTargetSelector :: GetReferencedByResponseReferencedByItemTargetSelector,
    getReferencedByResponseReferencedByItemTargetSource :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON GetReferencedByResponseReferencedByItemTarget where parseJSON = checked "GetReferencedByResponseReferencedByItemTarget" $ withObject "GetReferencedByResponseReferencedByItemTarget" (\fields -> GetReferencedByResponseReferencedByItemTarget <$> (fields .: "selector") <*> (fields .: "source"))

instance ToJSON GetReferencedByResponseReferencedByItemTarget where toJSON value = Object (KM.fromList (concat [[("selector", toJSON (getReferencedByResponseReferencedByItemTargetSelector value))], [("source", toJSON (getReferencedByResponseReferencedByItemTargetSource value))]]))

data GetReferencedByResponseReferencedByItemTargetSelector = GetReferencedByResponseReferencedByItemTargetSelector
  { getReferencedByResponseReferencedByItemTargetSelectorExact :: Text
  }
  deriving (Eq, Show)

instance FromJSON GetReferencedByResponseReferencedByItemTargetSelector where parseJSON = checked "GetReferencedByResponseReferencedByItemTargetSelector" $ withObject "GetReferencedByResponseReferencedByItemTargetSelector" (\fields -> GetReferencedByResponseReferencedByItemTargetSelector <$> (fields .: "exact"))

instance ToJSON GetReferencedByResponseReferencedByItemTargetSelector where toJSON value = Object (KM.fromList (concat [[("exact", toJSON (getReferencedByResponseReferencedByItemTargetSelectorExact value))]]))
