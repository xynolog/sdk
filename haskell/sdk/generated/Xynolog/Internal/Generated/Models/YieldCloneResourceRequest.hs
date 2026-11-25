-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldCloneResourceRequest (YieldCloneResourceRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data YieldCloneResourceRequest = YieldCloneResourceRequest
  { yieldCloneResourceRequestToken :: Text
  }
  deriving (Eq, Show)

instance FromJSON YieldCloneResourceRequest where parseJSON = checked "YieldCloneResourceRequest" $ withObject "YieldCloneResourceRequest" (\fields -> YieldCloneResourceRequest <$> (fields .: "token"))

instance ToJSON YieldCloneResourceRequest where toJSON value = Object (KM.fromList (concat [[("token", toJSON (yieldCloneResourceRequestToken value))]]))
