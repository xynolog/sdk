-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Inference (Inference (..), InferenceKind (..), InferenceSpec (..), InferenceSpecProviders (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ArchivistEngines
import Xynolog.Internal.Generated.Models.Metadata
import Xynolog.Internal.Generated.Models.Provider
import Xynolog.Internal.Generated.Models.StackApiVersion

data Inference = Inference
  { inferenceApiVersion :: StackApiVersion,
    inferenceKind :: InferenceKind,
    inferenceMetadata :: Metadata,
    inferenceSpec :: InferenceSpec
  }
  deriving (Eq, Show)

instance FromJSON Inference where parseJSON = checked "Inference" $ withObject "Inference" (\fields -> Inference <$> (fields .: "apiVersion") <*> (fields .: "kind") <*> (fields .: "metadata") <*> (fields .: "spec"))

instance ToJSON Inference where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (inferenceApiVersion value))], [("kind", toJSON (inferenceKind value))], [("metadata", toJSON (inferenceMetadata value))], [("spec", toJSON (inferenceSpec value))]]))

data InferenceKind = InferenceKindInference deriving (Eq, Show)

instance FromJSON InferenceKind where parseJSON = checked "InferenceKind" $ \value -> if value == String "Inference" then pure InferenceKindInference else fail "unknown enumeration member"

instance ToJSON InferenceKind where toJSON InferenceKindInference = String "Inference"

data InferenceSpec = InferenceSpec
  { inferenceSpecEngines :: ArchivistEngines,
    inferenceSpecProviders :: InferenceSpecProviders
  }
  deriving (Eq, Show)

instance FromJSON InferenceSpec where parseJSON = checked "InferenceSpec" $ withObject "InferenceSpec" (\fields -> InferenceSpec <$> (fields .: "engines") <*> (fields .: "providers"))

instance ToJSON InferenceSpec where toJSON value = Object (KM.fromList (concat [[("engines", toJSON (inferenceSpecEngines value))], [("providers", toJSON (inferenceSpecProviders value))]]))

data InferenceSpecProviders = InferenceSpecProviders
  { inferenceSpecProvidersAdditionalProperties :: KM.KeyMap Provider
  }
  deriving (Eq, Show)

instance FromJSON InferenceSpecProviders where parseJSON = checked "InferenceSpecProviders" $ withObject "InferenceSpecProviders" (\fields -> InferenceSpecProviders <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON InferenceSpecProviders where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (inferenceSpecProvidersAdditionalProperties value)))
