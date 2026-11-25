-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BeckonHoverEvent (BeckonHoverEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId

data BeckonHoverEvent = BeckonHoverEvent
  { beckonHoverEventAnnotationId :: Maybe AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON BeckonHoverEvent where parseJSON = checked "BeckonHoverEvent" $ withObject "BeckonHoverEvent" (\fields -> BeckonHoverEvent <$> (fields .: "annotationId"))

instance ToJSON BeckonHoverEvent where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (beckonHoverEventAnnotationId value))]]))
