-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StatusResponse (StatusResponse (..), StatusResponseFeatures (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data StatusResponse = StatusResponse
  { statusResponseAuthenticatedAs :: Maybe Text,
    statusResponseFeatures :: StatusResponseFeatures,
    statusResponseMessage :: Text,
    statusResponseStatus :: Text,
    statusResponseVersion :: Text
  }
  deriving (Eq, Show)

instance FromJSON StatusResponse where parseJSON = checked "StatusResponse" $ withObject "StatusResponse" (\fields -> StatusResponse <$> optional fields "authenticatedAs" <*> (fields .: "features") <*> (fields .: "message") <*> (fields .: "status") <*> (fields .: "version"))

instance ToJSON StatusResponse where toJSON value = Object (KM.fromList (concat [optionalPair "authenticatedAs" (statusResponseAuthenticatedAs value), [("features", toJSON (statusResponseFeatures value))], [("message", toJSON (statusResponseMessage value))], [("status", toJSON (statusResponseStatus value))], [("version", toJSON (statusResponseVersion value))]]))

data StatusResponseFeatures = StatusResponseFeatures
  { statusResponseFeaturesCollaboration :: Text,
    statusResponseFeaturesSemanticContent :: Text
  }
  deriving (Eq, Show)

instance FromJSON StatusResponseFeatures where parseJSON = checked "StatusResponseFeatures" $ withObject "StatusResponseFeatures" (\fields -> StatusResponseFeatures <$> (fields .: "collaboration") <*> (fields .: "semanticContent"))

instance ToJSON StatusResponseFeatures where toJSON value = Object (KM.fromList (concat [[("collaboration", toJSON (statusResponseFeaturesCollaboration value))], [("semanticContent", toJSON (statusResponseFeaturesSemanticContent value))]]))
