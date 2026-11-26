-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ProfilesProjection (ProfilesProjection (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Profile

data ProfilesProjection = ProfilesProjection
  { profilesProjectionProfiles :: KM.KeyMap Profile
  }
  deriving (Eq, Show)

instance FromJSON ProfilesProjection where parseJSON = checked "ProfilesProjection" $ withObject "ProfilesProjection" (\fields -> ProfilesProjection <$> (fields .: "profiles"))

instance ToJSON ProfilesProjection where toJSON value = Object (KM.fromList (concat [[("profiles", toJSON (profilesProjectionProfiles value))]]))
