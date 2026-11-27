-- | The timing a caller may set: what a client keeps ('ClientTiming') and what
-- a transport keeps ('TransportTiming'). Every other timing is a constant of
-- "Xynolog.Timing".
module Xynolog.Timing.Settings
  ( ClientTiming (..),
    protocolClientTiming,
    TransportTiming (..),
    protocolTransportTiming,
    withOverrides,
  )
where

import Data.Aeson (FromJSON, Result (..), ToJSON, Value (..), fromJSON, toJSON)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Generated.ClientTiming (ClientTiming (..), protocolClientTiming)
import Xynolog.Internal.Generated.TransportTiming (TransportTiming (..), protocolTransportTiming)

-- | The record with each member 'overrides' states in its place. A name the
-- record does not hold is refused.
withOverrides :: (FromJSON timing, ToJSON timing) => timing -> Value -> Either String timing
withOverrides timing (Object overrides) = case toJSON timing of
  Object fields -> case fromJSON (Object (KM.union overrides fields)) of Error reason -> Left reason; Success value -> Right value
  _ -> Left "Timing is not an object"
withOverrides _ _ = Left "Timing overrides are not an object"
