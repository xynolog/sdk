{-# LANGUAGE OverloadedStrings #-}

module ResourceCases (resourceCases) where

import Control.Monad (forM_, unless)
import Data.Aeson (Result (..), Value (..), eitherDecodeStrict', fromJSON, toJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.Foldable (toList)
import Data.Text (Text)
import Data.Text qualified as Text
import System.FilePath ((</>))
import Xynolog.Internal.Required qualified as Required
import Xynolog.Resources qualified as Resources
import Xynolog.Types (Fault (..), ResourceDescriptor)

member :: Text -> Value -> Value
member name (Object fields) = maybe (error ("missing resource case member " ++ Text.unpack name)) id (KM.lookup (Key.fromText name) fields)
member _ _ = error "resource case is not an object"

require :: String -> Bool -> IO ()
require label good = unless good (ioError (userError label))

resourceCases :: FilePath -> IO ()
resourceCases root = do
  table <- Bytes.readFile (root </> "protocol/specs/src/resources/reader-cases.json") >>= either (ioError . userError) pure . eitherDecodeStrict'
  rows <- case member "cases" table of Array values -> pure (toList values); _ -> ioError (userError "resource cases is not an array")
  forM_ rows $ \row -> do
    let raw = member "resource" row
        refused = case row of Object fields -> KM.lookup "refused" fields == Just (Bool True); _ -> False
    case Required.faultOf "ResourceDescriptor" raw of
      Just issue -> do
        require ("valid resource refused: " ++ show row) refused
        require "resource refusal names the wrong member" (String (faultMember issue) == member "member" row)
        require "resource refusal names the wrong reason" (toJSON (faultReason issue) == member "reason" row)
      Nothing -> do
        require ("malformed resource passed its shared shape: " ++ show row) (not refused)
        resource <- case fromJSON raw of Error message -> ioError (userError message); Success value -> pure (value :: ResourceDescriptor)
        let expected key = case row of Object fields -> maybe Null id (KM.lookup key fields); _ -> error "resource row is not an object"
        require "resource primary representation differs" (toJSON (Resources.getPrimaryRepresentation resource) == expected "primaryRepresentation")
        require "resource primary media type differs" (toJSON (Resources.getPrimaryMediaType resource) == expected "primaryMediaType")
        require "resource entity types differ" (toJSON (Resources.getResourceEntityTypes resource) == member "entityTypes" row)
  putStrLn "PASS every resource reader case, including ordered common member/reason refusals"
