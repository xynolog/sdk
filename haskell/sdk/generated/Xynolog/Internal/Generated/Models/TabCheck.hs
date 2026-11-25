-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TabCheck (TabCheck (..), TabCheckGone (..), TabCheckReady (..), TabCheckUnknown (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.TabVerdict

data TabCheck = TabCheckGone TabCheckGone | TabCheckReady TabCheckReady | TabCheckUnknown TabCheckUnknown deriving (Eq, Show)

instance FromJSON TabCheck where parseJSON = checked "TabCheck" $ \value -> (TabCheckGone <$> parseJSON value) <|> (TabCheckReady <$> parseJSON value) <|> (TabCheckUnknown <$> parseJSON value)

instance ToJSON TabCheck where
  toJSON (TabCheckGone value) = toJSON value
  toJSON (TabCheckReady value) = toJSON value
  toJSON (TabCheckUnknown value) = toJSON value

data TabCheckGone = MkTabCheckGone
  { tabCheckGoneVerdict :: TabVerdict
  }
  deriving (Eq, Show)

instance FromJSON TabCheckGone where parseJSON = checked "TabCheckGone" $ withObject "TabCheckGone" (\fields -> MkTabCheckGone <$> (fields .: "verdict"))

instance ToJSON TabCheckGone where toJSON value = Object (KM.fromList (concat [[("verdict", toJSON (tabCheckGoneVerdict value))]]))

data TabCheckReady = MkTabCheckReady
  { tabCheckReadyMediaType :: Maybe Text,
    tabCheckReadyName :: Text,
    tabCheckReadyVerdict :: TabVerdict
  }
  deriving (Eq, Show)

instance FromJSON TabCheckReady where parseJSON = checked "TabCheckReady" $ withObject "TabCheckReady" (\fields -> MkTabCheckReady <$> optional fields "mediaType" <*> (fields .: "name") <*> (fields .: "verdict"))

instance ToJSON TabCheckReady where toJSON value = Object (KM.fromList (concat [optionalPair "mediaType" (tabCheckReadyMediaType value), [("name", toJSON (tabCheckReadyName value))], [("verdict", toJSON (tabCheckReadyVerdict value))]]))

data TabCheckUnknown = MkTabCheckUnknown
  { tabCheckUnknownVerdict :: TabVerdict
  }
  deriving (Eq, Show)

instance FromJSON TabCheckUnknown where parseJSON = checked "TabCheckUnknown" $ withObject "TabCheckUnknown" (\fields -> MkTabCheckUnknown <$> (fields .: "verdict"))

instance ToJSON TabCheckUnknown where toJSON value = Object (KM.fromList (concat [[("verdict", toJSON (tabCheckUnknownVerdict value))]]))
