-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkRequestedEvent (MarkRequestedEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationSelector
import Xynolog.Internal.Generated.Models.Motivation
import Xynolog.Internal.Generated.Models.ResourceId

data MarkRequestedEvent = MarkRequestedEvent
  { markRequestedEventSource :: ResourceId,
    markRequestedEventSelector :: AnnotationSelector,
    markRequestedEventMotivation :: Motivation
  }
  deriving (Eq, Show)

instance FromJSON MarkRequestedEvent where parseJSON = checked "MarkRequestedEvent" $ withObject "MarkRequestedEvent" (\fields -> MarkRequestedEvent <$> (fields .: "source") <*> (fields .: "selector") <*> (fields .: "motivation"))

instance ToJSON MarkRequestedEvent where toJSON value = Object (KM.fromList (concat [[("source", toJSON (markRequestedEventSource value))], [("selector", toJSON (markRequestedEventSelector value))], [("motivation", toJSON (markRequestedEventMotivation value))]]))
