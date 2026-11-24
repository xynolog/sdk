-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Browser (Browser (..), BrowserKind (..), BrowserSpec (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Image
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Resources
import Xynolog.Internal.Generated.Models.StackApiVersion

data Browser = Browser
  { browserApiVersion :: StackApiVersion,
    browserKind :: BrowserKind,
    browserMetadata :: Metadata,
    browserSpec :: BrowserSpec
  }
  deriving (Eq, Show)

instance FromJSON Browser where parseJSON = checked "Browser" $ withObject "Browser" (\fields -> Browser <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON Browser where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (browserApiVersion value))], [("kind", toJSON (browserKind value))], [("metadata", toJSON (browserMetadata value))], [("spec", toJSON (browserSpec value))]]))

data BrowserKind = BrowserKindBrowser deriving (Eq, Show)

instance FromJSON BrowserKind where parseJSON = checked "BrowserKind" $ \value -> if value == String "Browser" then pure BrowserKindBrowser else fail "unknown enumeration member"

instance ToJSON BrowserKind where toJSON BrowserKindBrowser = String "Browser"

data BrowserSpec = BrowserSpec
  { browserSpecImage :: Image,
    browserSpecPort :: Integer,
    browserSpecResources :: Resources
  }
  deriving (Eq, Show)

instance FromJSON BrowserSpec where parseJSON = checked "BrowserSpec" $ withObject "BrowserSpec" (\fields -> BrowserSpec <$> (fields .: "image") <*> (fields .: "port") <*> (fields .: "resources"))

instance ToJSON BrowserSpec where toJSON value = Object (KM.fromList (concat [[("image", toJSON (browserSpecImage value))], [("port", toJSON (browserSpecPort value))], [("resources", toJSON (browserSpecResources value))]]))
