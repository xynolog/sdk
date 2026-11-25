-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EmbeddingRequests (EmbeddingRequests (..), EmbeddingRequestsBusy (..), EmbeddingRequestsProviders (..), EmbeddingRequestsProvidersValue (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data EmbeddingRequests = EmbeddingRequests
  { embeddingRequestsComment :: Text,
    embeddingRequestsProviders :: EmbeddingRequestsProviders,
    embeddingRequestsRequestSeconds :: Integer,
    embeddingRequestsBusy :: EmbeddingRequestsBusy,
    embeddingRequestsStartAgain :: Integer
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequests where parseJSON = checked "EmbeddingRequests" $ withObject "EmbeddingRequests" (\fields -> EmbeddingRequests <$> (fields .: "$comment") <*> (fields .: "providers") <*> (fields .: "requestSeconds") <*> (fields .: "busy") <*> (fields .: "startAgain"))

instance ToJSON EmbeddingRequests where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (embeddingRequestsComment value))], [("providers", toJSON (embeddingRequestsProviders value))], [("requestSeconds", toJSON (embeddingRequestsRequestSeconds value))], [("busy", toJSON (embeddingRequestsBusy value))], [("startAgain", toJSON (embeddingRequestsStartAgain value))]]))

data EmbeddingRequestsBusy = EmbeddingRequestsBusy
  { embeddingRequestsBusyStatuses :: [Integer],
    embeddingRequestsBusyAgainAfterSeconds :: [Integer]
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequestsBusy where parseJSON = checked "EmbeddingRequestsBusy" $ withObject "EmbeddingRequestsBusy" (\fields -> EmbeddingRequestsBusy <$> (fields .: "statuses") <*> (fields .: "againAfterSeconds"))

instance ToJSON EmbeddingRequestsBusy where toJSON value = Object (KM.fromList (concat [[("statuses", toJSON (embeddingRequestsBusyStatuses value))], [("againAfterSeconds", toJSON (embeddingRequestsBusyAgainAfterSeconds value))]]))

data EmbeddingRequestsProviders = EmbeddingRequestsProviders
  { embeddingRequestsProvidersAdditionalProperties :: KM.KeyMap EmbeddingRequestsProvidersValue
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequestsProviders where parseJSON = checked "EmbeddingRequestsProviders" $ withObject "EmbeddingRequestsProviders" (\fields -> EmbeddingRequestsProviders <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON EmbeddingRequestsProviders where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (embeddingRequestsProvidersAdditionalProperties value)))

data EmbeddingRequestsProvidersValue = EmbeddingRequestsProvidersValue
  { embeddingRequestsProvidersValueTextsPerRequest :: Integer,
    embeddingRequestsProvidersValueAtOnce :: Integer
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequestsProvidersValue where parseJSON = checked "EmbeddingRequestsProvidersValue" $ withObject "EmbeddingRequestsProvidersValue" (\fields -> EmbeddingRequestsProvidersValue <$> (fields .: "textsPerRequest") <*> (fields .: "atOnce"))

instance ToJSON EmbeddingRequestsProvidersValue where toJSON value = Object (KM.fromList (concat [[("textsPerRequest", toJSON (embeddingRequestsProvidersValueTextsPerRequest value))], [("atOnce", toJSON (embeddingRequestsProvidersValueAtOnce value))]]))
