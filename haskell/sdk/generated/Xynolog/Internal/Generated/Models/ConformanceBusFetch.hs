-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceBusFetch (ConformanceBusFetch (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ConformanceBusFetch = ConformanceBusFetch
  { conformanceBusFetchAs :: Text,
    conformanceBusFetchFetch :: Text,
    conformanceBusFetchPayload :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceBusFetch where parseJSON = checked "ConformanceBusFetch" $ withObject "ConformanceBusFetch" (\fields -> ConformanceBusFetch <$> (fields .: "as") <*> (fields .: "fetch") <*> optional fields "payload")

instance ToJSON ConformanceBusFetch where toJSON value = Object (KM.fromList (concat [[("as", toJSON (conformanceBusFetchAs value))], [("fetch", toJSON (conformanceBusFetchFetch value))], optionalPair "payload" (conformanceBusFetchPayload value)]))
