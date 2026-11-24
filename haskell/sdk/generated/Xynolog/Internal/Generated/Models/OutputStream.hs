-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OutputStream (OutputStream (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec

data OutputStream = OutputStreamStdout | OutputStreamStderr deriving (Eq, Show)

instance FromJSON OutputStream where parseJSON = checked "OutputStream" $ \value -> if value == String "stdout" then pure OutputStreamStdout else if value == String "stderr" then pure OutputStreamStderr else fail "unknown enumeration member"

instance ToJSON OutputStream where
  toJSON OutputStreamStdout = String "stdout"
  toJSON OutputStreamStderr = String "stderr"
