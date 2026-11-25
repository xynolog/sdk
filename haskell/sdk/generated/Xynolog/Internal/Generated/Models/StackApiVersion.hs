-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StackApiVersion (StackApiVersion (..), stackApiVersionText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data StackApiVersion = StackApiVersionXynologOrgV1alpha1 deriving (Eq, Show)

instance FromJSON StackApiVersion where parseJSON = checked "StackApiVersion" $ \value -> if value == String "xynolog.org/v1alpha1" then pure StackApiVersionXynologOrgV1alpha1 else fail "unknown enumeration member"

instance ToJSON StackApiVersion where toJSON StackApiVersionXynologOrgV1alpha1 = String "xynolog.org/v1alpha1"

stackApiVersionText :: StackApiVersion -> Text
stackApiVersionText StackApiVersionXynologOrgV1alpha1 = "xynolog.org/v1alpha1"
