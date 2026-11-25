-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceBusFetch (ConformanceBusFetch (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ConformanceBusFetch = ConformanceBusFetch
  { conformanceBusFetchFetch :: Text,
    conformanceBusFetchPayload :: Maybe Value,
    conformanceBusFetchAs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceBusFetch where parseJSON = checked "ConformanceBusFetch" $ withObject "ConformanceBusFetch" (\fields -> ConformanceBusFetch <$> (fields .: "fetch") <*> optional fields "payload" <*> (fields .: "as"))

instance ToJSON ConformanceBusFetch where toJSON value = Object (KM.fromList (concat [[("fetch", toJSON (conformanceBusFetchFetch value))], optionalPair "payload" (conformanceBusFetchPayload value), [("as", toJSON (conformanceBusFetchAs value))]]))
