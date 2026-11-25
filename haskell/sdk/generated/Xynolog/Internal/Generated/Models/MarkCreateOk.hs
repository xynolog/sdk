-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkCreateOk (MarkCreateOk (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MarkCreateOkResponse

data MarkCreateOk = MarkCreateOk
  { markCreateOkResponse :: MarkCreateOkResponse
  }
  deriving (Eq, Show)

instance FromJSON MarkCreateOk where parseJSON = checked "MarkCreateOk" $ withObject "MarkCreateOk" (\fields -> MarkCreateOk <$> (fields .: "response"))

instance ToJSON MarkCreateOk where toJSON value = Object (KM.fromList (concat [[("response", toJSON (markCreateOkResponse value))]]))
