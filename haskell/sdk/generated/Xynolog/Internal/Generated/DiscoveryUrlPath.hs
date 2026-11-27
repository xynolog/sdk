-- Generated from protocol/specs/src/client/surface.json; do not edit.
-- Regenerate: make generate (codegen/lib/discovery_url_path.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.DiscoveryUrlPath (discoveryUrlPath) where

import Data.Text (Text)

-- | Where a launcher's discovery document is: its path under the state home, and the URL path a browser fetches it at.
discoveryUrlPath :: Text
discoveryUrlPath = "/discovery/kbs.json"
