-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SignedIn (SignedIn (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbDescription
import Xynolog.Internal.Generated.Models.KbEndpoint
import Xynolog.Internal.Generated.Models.StoredSession

data SignedIn = SignedIn
  { signedInEndpoint :: KbEndpoint,
    signedInDescription :: KbDescription,
    signedInSession :: StoredSession,
    signedInKbId :: Maybe Text,
    signedInExpectedDid :: Maybe Text,
    signedInExpectedName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON SignedIn where parseJSON = checked "SignedIn" $ withObject "SignedIn" (\fields -> SignedIn <$> (fields .: "endpoint") <*> (fields .: "description") <*> (fields .: "session") <*> optional fields "kbId" <*> optional fields "expectedDid" <*> optional fields "expectedName")

instance ToJSON SignedIn where toJSON value = Object (KM.fromList (concat [[("endpoint", toJSON (signedInEndpoint value))], [("description", toJSON (signedInDescription value))], [("session", toJSON (signedInSession value))], optionalPair "kbId" (signedInKbId value), optionalPair "expectedDid" (signedInExpectedDid value), optionalPair "expectedName" (signedInExpectedName value)]))
