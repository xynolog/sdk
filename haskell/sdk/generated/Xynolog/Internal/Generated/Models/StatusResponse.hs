-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StatusResponse (StatusResponse (..), StatusResponseFeatures (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data StatusResponse = StatusResponse
  { statusResponseStatus :: Text,
    statusResponseVersion :: Text,
    statusResponseFeatures :: StatusResponseFeatures,
    statusResponseMessage :: Text,
    statusResponseAuthenticatedAs :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON StatusResponse where parseJSON = checked "StatusResponse" $ withObject "StatusResponse" (\fields -> StatusResponse <$> (fields .: "status") <*> (fields .: "version") <*> (fields .: "features") <*> (fields .: "message") <*> optional fields "authenticatedAs")

instance ToJSON StatusResponse where toJSON value = Object (KM.fromList (concat [[("status", toJSON (statusResponseStatus value))], [("version", toJSON (statusResponseVersion value))], [("features", toJSON (statusResponseFeatures value))], [("message", toJSON (statusResponseMessage value))], optionalPair "authenticatedAs" (statusResponseAuthenticatedAs value)]))

data StatusResponseFeatures = StatusResponseFeatures
  { statusResponseFeaturesSemanticContent :: Text,
    statusResponseFeaturesCollaboration :: Text
  }
  deriving (Eq, Show)

instance FromJSON StatusResponseFeatures where parseJSON = checked "StatusResponseFeatures" $ withObject "StatusResponseFeatures" (\fields -> StatusResponseFeatures <$> (fields .: "semanticContent") <*> (fields .: "collaboration"))

instance ToJSON StatusResponseFeatures where toJSON value = Object (KM.fromList (concat [[("semanticContent", toJSON (statusResponseFeaturesSemanticContent value))], [("collaboration", toJSON (statusResponseFeaturesCollaboration value))]]))
