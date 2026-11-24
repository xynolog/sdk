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
  { userActionExpiresInSeconds :: Integer,
    userActionRequestId :: RequestId,
    userActionUserCode :: Text,
    userActionVerificationUri :: Text,
    userActionVerificationUriComplete :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON UserAction where parseJSON = checked "UserAction" $ withObject "UserAction" (\fields -> UserAction <$> (fields .: "expiresInSeconds") <*> (fields .: "requestId") <*> (fields .: "userCode") <*> (fields .: "verificationUri") <*> optional fields "verificationUriComplete")

instance ToJSON UserAction where toJSON value = Object (KM.fromList (concat [[("expiresInSeconds", toJSON (userActionExpiresInSeconds value))], [("requestId", toJSON (userActionRequestId value))], [("userCode", toJSON (userActionUserCode value))], [("verificationUri", toJSON (userActionVerificationUri value))], optionalPair "verificationUriComplete" (userActionVerificationUriComplete value)]))
