-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AboutResult (AboutResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RuntimeState

data AboutResult = AboutResult
  { aboutResultApiVersions :: [Text],
    aboutResultBuilt :: Maybe Text,
    aboutResultCommit :: Maybe Text,
    aboutResultDevelopment :: Bool,
    aboutResultImageRegistry :: Text,
    aboutResultRuntimes :: [RuntimeState],
    aboutResultVersion :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON AboutResult where parseJSON = checked "AboutResult" $ withObject "AboutResult" (\fields -> AboutResult <$> (fields .: "apiVersions") <*> optional fields "built" <*> optional fields "commit" <*> (fields .: "development") <*> (fields .: "imageRegistry") <*> (fields .: "runtimes") <*> optional fields "version")

instance ToJSON AboutResult where toJSON value = Object (KM.fromList (concat [[("apiVersions", toJSON (aboutResultApiVersions value))], optionalPair "built" (aboutResultBuilt value), optionalPair "commit" (aboutResultCommit value), [("development", toJSON (aboutResultDevelopment value))], [("imageRegistry", toJSON (aboutResultImageRegistry value))], [("runtimes", toJSON (aboutResultRuntimes value))], optionalPair "version" (aboutResultVersion value)]))
