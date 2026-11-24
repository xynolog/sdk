-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceHttpFetch (ConformanceHttpFetch (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ConformanceHttpFetch = ConformanceHttpFetch
  { conformanceHttpFetchFetch :: Text,
    conformanceHttpFetchParams :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceHttpFetch where parseJSON = checked "ConformanceHttpFetch" $ withObject "ConformanceHttpFetch" (\fields -> ConformanceHttpFetch <$> (fields .: "fetch") <*> optional fields "params")

instance ToJSON ConformanceHttpFetch where toJSON value = Object (KM.fromList (concat [[("fetch", toJSON (conformanceHttpFetchFetch value))], optionalPair "params" (conformanceHttpFetchParams value)]))
