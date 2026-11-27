{-# LANGUAGE OverloadedStrings #-}

-- | CacheState, written by hand, held to its schema in
-- protocol/specs/src/client/types: a branch or a member either side gains or
-- loses fails. 'told' matches every constructor, so one CacheState gains does
-- not compile until it is told here. SearchState and JobEvent are generated
-- from their schemas.
module ClientTypesCensusCases (clientTypesCensusCases) where

import Control.Exception (ErrorCall (..), toException)
import Control.Monad (unless)
import Data.Aeson (Value (..), eitherDecodeStrict')
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.Foldable (toList)
import Data.List (sort)
import Data.Text (Text)
import Data.Text qualified as Text
import System.FilePath ((</>))
import Xynolog.Cache (CacheState (..))

-- | A state's status, and the members it holds.
told :: CacheState () -> (Text, [Text])
told Pending = ("pending", ["status"])
told (Ready ()) = ("ready", ["status", "value"])
told (Failed _) = ("failed", ["error", "status"])

states :: [CacheState ()]
states = [Pending, Ready (), Failed (toException (ErrorCall "failed"))]

fields :: Value -> KM.KeyMap Value
fields (Object members) = members
fields _ = error "a CacheState schema is not an object"

member :: Text -> Value -> Value
member name value = maybe (error ("the CacheState schema states no " ++ Text.unpack name)) id (KM.lookup (Key.fromText name) (fields value))

-- | A branch's status, the one value its @status@ states, and its members.
branch :: Value -> (Text, [Text])
branch schema = (status (member "enum" (member "status" properties)), sort (map Key.toText (KM.keys (fields properties))))
  where
    properties = member "properties" schema
    status (Array values) | [String word] <- toList values = word
    status _ = error "a CacheState branch states no one status"

clientTypesCensusCases :: FilePath -> IO ()
clientTypesCensusCases root = do
  schema <- Bytes.readFile (root </> "protocol/specs/src/client/types/CacheState.json") >>= either (ioError . userError) pure . eitherDecodeStrict'
  branches <- case member "oneOf" schema of
    Array each -> pure (sort (map branch (toList each)))
    _ -> ioError (userError "the CacheState schema is no oneOf")
  let written = sort (map told states)
  unless (written == branches) (ioError (userError ("CacheState is " ++ show written ++ ", and the schema states " ++ show branches)))
