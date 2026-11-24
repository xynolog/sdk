-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.EmbeddingRequests (EmbeddingRequests (..), EmbeddingRequestsBusy (..), EmbeddingRequestsProviders (..), EmbeddingRequestsProvidersAdditionalValue (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data EmbeddingRequests = EmbeddingRequests
  { embeddingRequestsU24_comment :: Text,
    embeddingRequestsBusy :: EmbeddingRequestsBusy,
    embeddingRequestsProviders :: EmbeddingRequestsProviders,
    embeddingRequestsRequestSeconds :: Integer,
    embeddingRequestsStartAgain :: Integer
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequests where parseJSON = checked "EmbeddingRequests" $ withObject "EmbeddingRequests" (\fields -> EmbeddingRequests <$> (fields .: "$comment") <*> (fields .: "busy") <*> (fields .: "providers") <*> (fields .: "requestSeconds") <*> (fields .: "startAgain"))

instance ToJSON EmbeddingRequests where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (embeddingRequestsU24_comment value))], [("busy", toJSON (embeddingRequestsBusy value))], [("providers", toJSON (embeddingRequestsProviders value))], [("requestSeconds", toJSON (embeddingRequestsRequestSeconds value))], [("startAgain", toJSON (embeddingRequestsStartAgain value))]]))

data EmbeddingRequestsBusy = EmbeddingRequestsBusy
  { embeddingRequestsBusyAgainAfterSeconds :: [Integer],
    embeddingRequestsBusyStatuses :: [Integer]
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequestsBusy where parseJSON = checked "EmbeddingRequestsBusy" $ withObject "EmbeddingRequestsBusy" (\fields -> EmbeddingRequestsBusy <$> (fields .: "againAfterSeconds") <*> (fields .: "statuses"))

instance ToJSON EmbeddingRequestsBusy where toJSON value = Object (KM.fromList (concat [[("againAfterSeconds", toJSON (embeddingRequestsBusyAgainAfterSeconds value))], [("statuses", toJSON (embeddingRequestsBusyStatuses value))]]))

data EmbeddingRequestsProviders = EmbeddingRequestsProviders
  { embeddingRequestsProvidersAdditionalProperties :: KM.KeyMap EmbeddingRequestsProvidersAdditionalValue
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequestsProviders where parseJSON = checked "EmbeddingRequestsProviders" $ withObject "EmbeddingRequestsProviders" (\fields -> EmbeddingRequestsProviders <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON EmbeddingRequestsProviders where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (embeddingRequestsProvidersAdditionalProperties value)))

data EmbeddingRequestsProvidersAdditionalValue = EmbeddingRequestsProvidersAdditionalValue
  { embeddingRequestsProvidersAdditionalValueAtOnce :: Integer,
    embeddingRequestsProvidersAdditionalValueTextsPerRequest :: Integer
  }
  deriving (Eq, Show)

instance FromJSON EmbeddingRequestsProvidersAdditionalValue where parseJSON = checked "EmbeddingRequestsProvidersAdditionalValue" $ withObject "EmbeddingRequestsProvidersAdditionalValue" (\fields -> EmbeddingRequestsProvidersAdditionalValue <$> (fields .: "atOnce") <*> (fields .: "textsPerRequest"))

instance ToJSON EmbeddingRequestsProvidersAdditionalValue where toJSON value = Object (KM.fromList (concat [[("atOnce", toJSON (embeddingRequestsProvidersAdditionalValueAtOnce value))], [("textsPerRequest", toJSON (embeddingRequestsProvidersAdditionalValueTextsPerRequest value))]]))
