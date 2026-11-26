-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Fault (Fault (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FrameRefusalReason

data Fault = Fault
  { faultMember :: Text,
    faultReason :: FrameRefusalReason
  }
  deriving (Eq, Show)

instance FromJSON Fault where parseJSON = checked "Fault" $ withObject "Fault" (\fields -> Fault <$> (fields .: "member") <*> (fields .: "reason"))

instance ToJSON Fault where toJSON value = Object (KM.fromList (concat [[("member", toJSON (faultMember value))], [("reason", toJSON (faultReason value))]]))
