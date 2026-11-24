-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Runtime (Runtime (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec

data Runtime = RuntimeContainer | RuntimeDocker | RuntimePodman deriving (Eq, Show)

instance FromJSON Runtime where parseJSON = checked "Runtime" $ \value -> if value == String "container" then pure RuntimeContainer else if value == String "docker" then pure RuntimeDocker else if value == String "podman" then pure RuntimePodman else fail "unknown enumeration member"

instance ToJSON Runtime where
  toJSON RuntimeContainer = String "container"
  toJSON RuntimeDocker = String "docker"
  toJSON RuntimePodman = String "podman"
