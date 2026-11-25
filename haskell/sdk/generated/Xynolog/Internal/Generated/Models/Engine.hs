-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Engine (Engine (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.InferenceProvider

data Engine = Engine
  { engineProvider :: InferenceProvider,
    engineModel :: Text
  }
  deriving (Eq, Show)

instance FromJSON Engine where parseJSON = checked "Engine" $ withObject "Engine" (\fields -> Engine <$> (fields .: "provider") <*> (fields .: "model"))

instance ToJSON Engine where toJSON value = Object (KM.fromList (concat [[("provider", toJSON (engineProvider value))], [("model", toJSON (engineModel value))]]))
