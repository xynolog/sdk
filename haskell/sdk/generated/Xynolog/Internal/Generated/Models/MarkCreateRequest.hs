-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkCreateRequest (MarkCreateRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.CreateAnnotationRequest
import Xynolog.Internal.Generated.Models.ResourceId

data MarkCreateRequest = MarkCreateRequest
  { markCreateRequestResourceId :: ResourceId,
    markCreateRequestRequest :: CreateAnnotationRequest
  }
  deriving (Eq, Show)

instance FromJSON MarkCreateRequest where parseJSON = checked "MarkCreateRequest" $ withObject "MarkCreateRequest" (\fields -> MarkCreateRequest <$> (fields .: "resourceId") <*> (fields .: "request"))

instance ToJSON MarkCreateRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (markCreateRequestResourceId value))], [("request", toJSON (markCreateRequestRequest value))]]))
