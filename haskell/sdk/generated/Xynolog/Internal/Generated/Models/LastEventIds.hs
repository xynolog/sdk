-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LastEventIds (LastEventIds) where

import Data.Map.Strict qualified as Map
import Xynolog.Internal.Generated.Models.PersistedEventId
import Xynolog.Internal.Generated.Models.ResourceId

type LastEventIds = Map.Map ResourceId PersistedEventId
