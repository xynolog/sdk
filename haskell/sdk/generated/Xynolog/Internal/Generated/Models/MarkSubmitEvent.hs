-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkSubmitEvent (MarkSubmitEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBodies
import Xynolog.Internal.Generated.Models.AnnotationSelector
import Xynolog.Internal.Generated.Models.Motivation
import Xynolog.Internal.Generated.Models.ResourceId

data MarkSubmitEvent = MarkSubmitEvent
  { markSubmitEventBody :: Maybe AnnotationBodies,
    markSubmitEventMotivation :: Motivation,
    markSubmitEventSelector :: AnnotationSelector,
    markSubmitEventSource :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON MarkSubmitEvent where parseJSON = checked "MarkSubmitEvent" $ withObject "MarkSubmitEvent" (\fields -> MarkSubmitEvent <$> optional fields "body" <*> (fields .: "motivation") <*> (fields .: "selector") <*> (fields .: "source"))

instance ToJSON MarkSubmitEvent where toJSON value = Object (KM.fromList (concat [optionalPair "body" (markSubmitEventBody value), [("motivation", toJSON (markSubmitEventMotivation value))], [("selector", toJSON (markSubmitEventSelector value))], [("source", toJSON (markSubmitEventSource value))]]))
