{-# LANGUAGE OverloadedStrings #-}

-- | protocol/specs/src/client/shape-cases.json: the table every SDK's reading
-- of a value runs. Each case's value is held to the schema it names, and its
-- first fault is the one the case states, or none.
module ShapeCases (shapeCases) where

import Control.Monad (forM_, unless, when)
import Data.Aeson (Result (..), Value (..), eitherDecodeStrict', fromJSON)
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.Foldable (toList)
import Data.Text (Text)
import Data.Text qualified as Text
import System.FilePath ((</>))
import Xynolog.Internal.Required qualified as Required
import Xynolog.Types (Fault (..), FrameRefusalReason)

require :: String -> Bool -> IO ()
require label good = unless good (ioError (userError label))

member :: Text -> Value -> Value
member name (Object fields) = maybe (error ("missing shape case member " ++ Text.unpack name)) id (KM.lookup (Key.fromText name) fields)
member _ _ = error "shape case is not an object"

text :: Value -> Text
text (String held) = held
text other = error ("shape case member is not a text: " ++ show other)

reasonNamed :: Value -> FrameRefusalReason
reasonNamed value = case fromJSON value of
  Success reason -> reason
  Error problem -> error ("unknown shape case reason: " ++ problem)

-- | Each case's value held to its schema's shape from the top: a schema the
-- table lacks fails loudly in the walker's lookup of it.
shapeCases :: FilePath -> IO ()
shapeCases root = do
  table <- Bytes.readFile (root </> "protocol/specs/src" </> "client/shape-cases.json") >>= either (ioError . userError) pure . eitherDecodeStrict'
  rows <- case member "cases" table of Array cases -> pure (toList cases); _ -> ioError (userError "shape cases is not an array")
  when (null rows) (ioError (userError "shape-cases.json states no case"))
  forM_ rows $ \row -> do
    let name = text (member "schema" row)
        value = member "value" row
        refused = case row of Object fields -> KM.lookup "refused" fields == Just (Bool True); _ -> False
        expected
          | refused = Just (Fault (text (member "member" row)) (reasonNamed (member "reason" row)))
          | otherwise = Nothing
        actual = Required.faultOf name value
    require
      (Text.unpack (text (member "why" row)) ++ ": " ++ show value ++ " as " ++ Text.unpack name ++ " has the fault " ++ show actual ++ ", not " ++ show expected)
      (actual == expected)
  putStrLn "PASS every shape case, each value's first fault as its case states"
