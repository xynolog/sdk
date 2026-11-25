-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.UserAction (UserAction (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RequestId

data UserAction = UserAction
  { userActionRequestId :: RequestId,
    userActionVerificationUri :: Text,
    userActionVerificationUriComplete :: Maybe Text,
    userActionUserCode :: Text,
    userActionExpiresInSeconds :: Integer
  }
  deriving (Eq, Show)

instance FromJSON UserAction where parseJSON = checked "UserAction" $ withObject "UserAction" (\fields -> UserAction <$> (fields .: "requestId") <*> (fields .: "verificationUri") <*> optional fields "verificationUriComplete" <*> (fields .: "userCode") <*> (fields .: "expiresInSeconds"))

instance ToJSON UserAction where toJSON value = Object (KM.fromList (concat [[("requestId", toJSON (userActionRequestId value))], [("verificationUri", toJSON (userActionVerificationUri value))], optionalPair "verificationUriComplete" (userActionVerificationUriComplete value), [("userCode", toJSON (userActionUserCode value))], [("expiresInSeconds", toJSON (userActionExpiresInSeconds value))]]))
