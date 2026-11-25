-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceStarted (ServiceStarted (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RequestId
import Xynolog.Internal.Generated.Models.RunInstance

data ServiceStarted = ServiceStarted
  { serviceStartedRequestId :: RequestId,
    serviceStartedInstance :: RunInstance,
    serviceStartedContainer :: Text,
    serviceStartedDocumentPath :: Maybe Text,
    serviceStartedAddress :: Text
  }
  deriving (Eq, Show)

instance FromJSON ServiceStarted where parseJSON = checked "ServiceStarted" $ withObject "ServiceStarted" (\fields -> ServiceStarted <$> (fields .: "requestId") <*> (fields .: "instance") <*> (fields .: "container") <*> optional fields "documentPath" <*> (fields .: "address"))

instance ToJSON ServiceStarted where toJSON value = Object (KM.fromList (concat [[("requestId", toJSON (serviceStartedRequestId value))], [("instance", toJSON (serviceStartedInstance value))], [("container", toJSON (serviceStartedContainer value))], optionalPair "documentPath" (serviceStartedDocumentPath value), [("address", toJSON (serviceStartedAddress value))]]))
