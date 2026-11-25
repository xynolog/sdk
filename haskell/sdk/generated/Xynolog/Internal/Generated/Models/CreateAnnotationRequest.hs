-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CreateAnnotationRequest (CreateAnnotationRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationBodies
import Xynolog.Internal.Generated.Models.AnnotationTarget
import Xynolog.Internal.Generated.Models.Motivation

data CreateAnnotationRequest = CreateAnnotationRequest
  { createAnnotationRequestMotivation :: Motivation,
    createAnnotationRequestTarget :: AnnotationTarget,
    createAnnotationRequestBody :: Maybe AnnotationBodies
  }
  deriving (Eq, Show)

instance FromJSON CreateAnnotationRequest where parseJSON = checked "CreateAnnotationRequest" $ withObject "CreateAnnotationRequest" (\fields -> CreateAnnotationRequest <$> (fields .: "motivation") <*> (fields .: "target") <*> optional fields "body")

instance ToJSON CreateAnnotationRequest where toJSON value = Object (KM.fromList (concat [[("motivation", toJSON (createAnnotationRequestMotivation value))], [("target", toJSON (createAnnotationRequestTarget value))], optionalPair "body" (createAnnotationRequestBody value)]))
