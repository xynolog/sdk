-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ApiVersion (ApiVersion (..), apiVersionText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data ApiVersion = ApiVersionControlXynologOrgV1alpha1 deriving (Eq, Show)

instance FromJSON ApiVersion where parseJSON = checked "ApiVersion" $ \value -> if value == String "control.xynolog.org/v1alpha1" then pure ApiVersionControlXynologOrgV1alpha1 else fail "unknown enumeration member"

instance ToJSON ApiVersion where toJSON ApiVersionControlXynologOrgV1alpha1 = String "control.xynolog.org/v1alpha1"

apiVersionText :: ApiVersion -> Text
apiVersionText ApiVersionControlXynologOrgV1alpha1 = "control.xynolog.org/v1alpha1"
