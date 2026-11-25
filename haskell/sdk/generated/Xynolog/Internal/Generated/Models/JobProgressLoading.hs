-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressLoading (JobProgressLoading (..), JobProgressLoadingCode (..), jobProgressLoadingCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobProgressLoading = JobProgressLoading
  { jobProgressLoadingCode :: JobProgressLoadingCode
  }
  deriving (Eq, Show)

instance FromJSON JobProgressLoading where parseJSON = checked "JobProgressLoading" $ withObject "JobProgressLoading" (\fields -> JobProgressLoading <$> (fields .: "code"))

instance ToJSON JobProgressLoading where toJSON value = Object (KM.fromList (concat [[("code", toJSON (jobProgressLoadingCode value))]]))

data JobProgressLoadingCode = JobProgressLoadingCodeLoading deriving (Eq, Show)

instance FromJSON JobProgressLoadingCode where parseJSON = checked "JobProgressLoadingCode" $ \value -> if value == String "loading" then pure JobProgressLoadingCodeLoading else fail "unknown enumeration member"

instance ToJSON JobProgressLoadingCode where toJSON JobProgressLoadingCodeLoading = String "loading"

jobProgressLoadingCodeText :: JobProgressLoadingCode -> Text
jobProgressLoadingCodeText JobProgressLoadingCodeLoading = "loading"
