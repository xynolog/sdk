-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbTarget (KbTarget (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbEndpoint

data KbTarget = KbTarget
  { kbTargetId :: Text,
    kbTargetLabel :: Text,
    kbTargetEndpoint :: KbEndpoint
  }
  deriving (Eq, Show)

instance FromJSON KbTarget where parseJSON = checked "KbTarget" $ withObject "KbTarget" (\fields -> KbTarget <$> (fields .: "id") <*> (fields .: "label") <*> (fields .: "endpoint"))

instance ToJSON KbTarget where toJSON value = Object (KM.fromList (concat [[("id", toJSON (kbTargetId value))], [("label", toJSON (kbTargetLabel value))], [("endpoint", toJSON (kbTargetEndpoint value))]]))
