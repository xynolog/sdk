-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BeckonFocusEvent (BeckonFocusEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId

data BeckonFocusEvent = BeckonFocusEvent
  { beckonFocusEventAnnotationId :: Maybe AnnotationId,
    beckonFocusEventResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BeckonFocusEvent where parseJSON = checked "BeckonFocusEvent" $ withObject "BeckonFocusEvent" (\fields -> BeckonFocusEvent <$> optional fields "annotationId" <*> (fields .: "resourceId"))

instance ToJSON BeckonFocusEvent where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (beckonFocusEventAnnotationId value), [("resourceId", toJSON (beckonFocusEventResourceId value))]]))
