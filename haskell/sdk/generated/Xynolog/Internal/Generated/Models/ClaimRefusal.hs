-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClaimRefusal (ClaimRefusal (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.ErrorCodes (BusRequestCode (..))
import Xynolog.Internal.Codec

data ClaimRefusal = ClaimRefusal
  { claimRefusalCode :: Maybe BusRequestCode,
    claimRefusalMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClaimRefusal where parseJSON = checked "ClaimRefusal" $ withObject "ClaimRefusal" (\fields -> ClaimRefusal <$> (fields .: "code") <*> (fields .: "message"))

instance ToJSON ClaimRefusal where toJSON value = Object (KM.fromList (concat [[("code", toJSON (claimRefusalCode value))], [("message", toJSON (claimRefusalMessage value))]]))
