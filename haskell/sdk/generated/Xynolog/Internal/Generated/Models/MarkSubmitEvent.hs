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
  { markSubmitEventSource :: ResourceId,
    markSubmitEventMotivation :: Motivation,
    markSubmitEventSelector :: AnnotationSelector,
    markSubmitEventBody :: Maybe AnnotationBodies
  }
  deriving (Eq, Show)

instance FromJSON MarkSubmitEvent where parseJSON = checked "MarkSubmitEvent" $ withObject "MarkSubmitEvent" (\fields -> MarkSubmitEvent <$> (fields .: "source") <*> (fields .: "motivation") <*> (fields .: "selector") <*> optional fields "body")

instance ToJSON MarkSubmitEvent where toJSON value = Object (KM.fromList (concat [[("source", toJSON (markSubmitEventSource value))], [("motivation", toJSON (markSubmitEventMotivation value))], [("selector", toJSON (markSubmitEventSelector value))], optionalPair "body" (markSubmitEventBody value)]))
