-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TabCheck (TabCheck (..), TabCheckGoneValue (..), TabCheckReadyValue (..), TabCheckUnknownValue (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.TabVerdict

data TabCheck = TabCheckGone TabCheckGoneValue | TabCheckReady TabCheckReadyValue | TabCheckUnknown TabCheckUnknownValue deriving (Eq, Show)

instance FromJSON TabCheck where parseJSON = checked "TabCheck" $ \value -> (TabCheckGone <$> parseJSON value) <|> (TabCheckReady <$> parseJSON value) <|> (TabCheckUnknown <$> parseJSON value)

instance ToJSON TabCheck where
  toJSON (TabCheckGone value) = toJSON value
  toJSON (TabCheckReady value) = toJSON value
  toJSON (TabCheckUnknown value) = toJSON value

data TabCheckGoneValue = TabCheckGoneValue
  { tabCheckGoneValueVerdict :: TabVerdict
  }
  deriving (Eq, Show)

instance FromJSON TabCheckGoneValue where parseJSON = checked "TabCheckGoneValue" $ withObject "TabCheckGoneValue" (\fields -> TabCheckGoneValue <$> (fields .: "verdict"))

instance ToJSON TabCheckGoneValue where toJSON value = Object (KM.fromList (concat [[("verdict", toJSON (tabCheckGoneValueVerdict value))]]))

data TabCheckReadyValue = TabCheckReadyValue
  { tabCheckReadyValueMediaType :: Maybe Text,
    tabCheckReadyValueName :: Text,
    tabCheckReadyValueVerdict :: TabVerdict
  }
  deriving (Eq, Show)

instance FromJSON TabCheckReadyValue where parseJSON = checked "TabCheckReadyValue" $ withObject "TabCheckReadyValue" (\fields -> TabCheckReadyValue <$> optional fields "mediaType" <*> (fields .: "name") <*> (fields .: "verdict"))

instance ToJSON TabCheckReadyValue where toJSON value = Object (KM.fromList (concat [optionalPair "mediaType" (tabCheckReadyValueMediaType value), [("name", toJSON (tabCheckReadyValueName value))], [("verdict", toJSON (tabCheckReadyValueVerdict value))]]))

data TabCheckUnknownValue = TabCheckUnknownValue
  { tabCheckUnknownValueVerdict :: TabVerdict
  }
  deriving (Eq, Show)

instance FromJSON TabCheckUnknownValue where parseJSON = checked "TabCheckUnknownValue" $ withObject "TabCheckUnknownValue" (\fields -> TabCheckUnknownValue <$> (fields .: "verdict"))

instance ToJSON TabCheckUnknownValue where toJSON value = Object (KM.fromList (concat [[("verdict", toJSON (tabCheckUnknownValueVerdict value))]]))
