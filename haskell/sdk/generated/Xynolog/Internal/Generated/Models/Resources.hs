-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Resources (Resources (..), ResourcesLimits (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Resources = Resources
  { resourcesLimits :: ResourcesLimits
  }
  deriving (Eq, Show)

instance FromJSON Resources where parseJSON = checked "Resources" $ withObject "Resources" (\fields -> Resources <$> (fields .: "limits"))

instance ToJSON Resources where toJSON value = Object (KM.fromList (concat [[("limits", toJSON (resourcesLimits value))]]))

data ResourcesLimits = ResourcesLimits
  { resourcesLimitsMemory :: Text
  }
  deriving (Eq, Show)

instance FromJSON ResourcesLimits where parseJSON = checked "ResourcesLimits" $ withObject "ResourcesLimits" (\fields -> ResourcesLimits <$> (fields .: "memory"))

instance ToJSON ResourcesLimits where toJSON value = Object (KM.fromList (concat [[("memory", toJSON (resourcesLimitsMemory value))]]))
