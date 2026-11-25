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
  { aboutResultVersion :: Maybe Text,
    aboutResultDevelopment :: Bool,
    aboutResultCommit :: Maybe Text,
    aboutResultBuilt :: Maybe Text,
    aboutResultApiVersions :: [Text],
    aboutResultImageRegistry :: Text,
    aboutResultRuntimes :: [RuntimeState]
  }
  deriving (Eq, Show)

instance FromJSON AboutResult where parseJSON = checked "AboutResult" $ withObject "AboutResult" (\fields -> AboutResult <$> optional fields "version" <*> (fields .: "development") <*> optional fields "commit" <*> optional fields "built" <*> (fields .: "apiVersions") <*> (fields .: "imageRegistry") <*> (fields .: "runtimes"))

instance ToJSON AboutResult where toJSON value = Object (KM.fromList (concat [optionalPair "version" (aboutResultVersion value), [("development", toJSON (aboutResultDevelopment value))], optionalPair "commit" (aboutResultCommit value), optionalPair "built" (aboutResultBuilt value), [("apiVersions", toJSON (aboutResultApiVersions value))], [("imageRegistry", toJSON (aboutResultImageRegistry value))], [("runtimes", toJSON (aboutResultRuntimes value))]]))
