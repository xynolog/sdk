{-# LANGUAGE OverloadedStrings #-}

module SchemaCases (schemaCases) where

import Control.Monad (forM_, unless)
import Data.Aeson (Value (..), object, toJSON, (.=))
import Data.Either (isLeft)
import Data.Map.Strict qualified as Map
import Data.Text (Text)
import Xynolog.Internal.Schema

require :: String -> Bool -> IO ()
require label good = unless good (ioError (userError label))

schemaCases :: IO ()
schemaCases = do
  let text = object ["type" .= String "string"]
      definitions = Map.fromList [("Text", text)]
      checked = checkSchema definitions
      malformed label shape = require label (isLeft (checked shape))
      accepted label shape = require label (checked shape == Right ())
      holds shape value = require ("valid schema/value refused: " ++ show (shape, value)) (validate definitions shape value == Right ())
      refuses shape value = require ("invalid schema/value accepted: " ++ show (shape, value)) (isLeft (validate definitions shape value))
  accepted "empty schema refused" (object [])
  malformed "non-object schema accepted" Null
  malformed "unknown reference accepted" (ref "Missing")
  accepted "reference refused" (ref "Text")
  malformed "non-string reference accepted" (object ["$ref" .= True])
  malformed "unknown keyword accepted" (object ["patternProperties" .= object ["x" .= text]])
  forM_ ["not", "propertyNames"] $ \key -> do
    accepted "a keyword of a schema refused" (object [key .= text])
    malformed "a keyword of no schema accepted" (object [key .= Number 1])
  accepted "const refused" (object ["const" .= String "a"])
  accepted "minProperties refused" (object ["minProperties" .= (1 :: Int)])
  malformed "unknown type accepted" (object ["type" .= String "unknown"])
  malformed "non-string type accepted" (object ["type" .= True])
  forM_ ["string", "integer", "number", "boolean", "object", "array", "null"] $ \kind ->
    accepted "known type refused" (object ["type" .= String kind])
  forM_ ["uri", "date-time", "binary"] $ \format -> accepted "known format refused" (object ["format" .= String format])
  malformed "unknown format accepted" (object ["format" .= String "unknown"])
  malformed "non-string format accepted" (object ["format" .= True])
  forM_ ["^x+$", "^[a-z\\-]+$", "^\\S+$", "^x.z$", "^[^/\\s]+/\\d\\w$"] $ \pattern ->
    accepted "supported pattern refused" (object ["pattern" .= String pattern])
  forM_ ["\\p", "[\\S]", "\\", "["] $ \pattern -> malformed "unsupported pattern accepted" (object ["pattern" .= String pattern])
  malformed "non-string pattern accepted" (object ["pattern" .= False])
  forM_ ["minimum", "maximum"] $ \key -> do
    accepted "numeric bound refused" (object [key .= (1.5 :: Double)])
    malformed "non-numeric bound accepted" (object [key .= True])
  forM_ ["minLength", "maxLength", "minItems", "maxItems", "maxProperties"] $ \key -> do
    accepted "whole non-negative bound refused" (object [key .= (1 :: Int)])
    forM_ [Number (-1), Number 0.5, Bool True] $ \value -> malformed "invalid length bound accepted" (object [key .= value])
  forM_ ["uniqueItems", "deprecated", "readOnly", "writeOnly"] $ \key -> do
    accepted "boolean annotation refused" (object [key .= True])
    malformed "non-boolean annotation accepted" (object [key .= Null])
  accepted "required list refused" (object ["required" .= [String "value"]])
  malformed "non-string required member accepted" (object ["required" .= [Bool True]])
  malformed "non-array required accepted" (object ["required" .= True])
  accepted "enum refused" (object ["enum" .= [String "a", String "b"]])
  forM_ [Array mempty, Bool True] $ \value -> malformed "invalid enum accepted" (object ["enum" .= value])
  malformed "duplicate enum accepted" (object ["enum" .= [String "a", String "a"]])
  accepted "nested properties refused" (object ["properties" .= object ["value" .= text]])
  malformed "non-object properties accepted" (object ["properties" .= True])
  accepted "array items refused" (object ["items" .= text])
  forM_ [Bool True, Bool False, text] $ \extra -> accepted "additional properties refused" (object ["additionalProperties" .= extra])
  malformed "allOf accepted, which the generator merges" (object ["allOf" .= [text]])
  forM_ ["oneOf", "anyOf"] $ \key -> do
    accepted "schema branches refused" (object [key .= [text]])
    malformed "empty branches accepted" (object [key .= ([] :: [Value])])
    malformed "non-array branches accepted" (object [key .= True])

  holds (ref "Text") (String "a")
  refuses (ref "Text") (Bool True)
  refuses (ref "Missing") (String "a")
  holds (object []) Null
  let nullableText = object ["type" .= [String "string", String "null"]]
  holds nullableText Null
  holds nullableText (String "a")
  refuses nullableText (Bool True)
  holds (object ["type" .= String "null"]) Null
  refuses (object ["type" .= String "null"]) (String "a")
  holds (object ["anyOf" .= [ref "Text", object ["type" .= String "null"]]]) Null
  accepted "a type and null refused" nullableText
  malformed "two types neither null accepted" (object ["type" .= [String "string", String "integer"]])
  malformed "nullable accepted, which is OpenAPI 3.0's" (object ["type" .= String "string", "nullable" .= True])
  refuses text Null
  forM_ [Bool True, Number 1, object [], Array mempty] (refuses text)
  let boundedText = object ["type" .= String "string", "minLength" .= (1 :: Int), "maxLength" .= (2 :: Int)]
  mapM_ (holds boundedText . String) ["a", "a\x1f600"]
  mapM_ (refuses boundedText . String) ["", "abc"]
  let integer = object ["type" .= String "integer", "minimum" .= (1 :: Int), "maximum" .= (2 :: Int)]
      number = object ["type" .= String "number", "minimum" .= (1 :: Int), "maximum" .= (2 :: Int)]
  mapM_ (holds integer . Number) [1, 2]
  mapM_ (refuses integer) [Number 0, Number 3, Number 1.5, Bool True]
  holds number (Number 1.5)
  mapM_ (refuses number) [Number 0.5, Number 2.5, Bool True]
  holds (object ["type" .= String "boolean"]) (Bool True)
  refuses (object ["type" .= String "boolean"]) (Number 1)
  let sequenceOf = object ["type" .= String "array", "items" .= text, "minItems" .= (1 :: Int), "maxItems" .= (2 :: Int), "uniqueItems" .= True]
  holds sequenceOf (toArray [String "a", String "b"])
  mapM_ (refuses sequenceOf) [toArray [], toArray [String "a", String "b", String "c"], toArray [String "a", String "a"], toArray [Bool True], Null]
  refuses (object ["type" .= String "array"]) (toArray [String "a"])
  let record = object ["type" .= String "object", "properties" .= object ["a" .= text], "required" .= [String "a"], "additionalProperties" .= False]
  holds record (object ["a" .= String "value"])
  mapM_ (refuses record) [object [], object ["a" .= True], object ["a" .= String "v", "extra" .= True], Null]
  holds (object ["type" .= String "object"]) (object ["extra" .= True])
  let dictionary = object ["type" .= String "object", "additionalProperties" .= text]
  holds dictionary (object ["a" .= String "value"])
  refuses dictionary (object ["a" .= True])
  refuses (object ["type" .= String "object", "maxProperties" .= (0 :: Int)]) (object ["a" .= True])
  forM_ ["oneOf", "anyOf"] $ \key -> do
    let union = object [key .= [text, object ["type" .= String "boolean"]]]
    holds union (String "a")
    holds union (Bool True)
    refuses union (Number 1)
  refuses (object ["oneOf" .= [text, text]]) (String "a")
  holds (object ["anyOf" .= [text, text]]) (String "a")
  holds (object ["type" .= String "string", "pattern" .= String "^a+$"]) (String "a")
  refuses (object ["type" .= String "string", "pattern" .= String "^a+$"]) (String "b")
  refuses (object ["enum" .= [String "a"]]) (String "b")
  holds (object ["const" .= String "a"]) (String "a")
  refuses (object ["const" .= String "a"]) (String "b")
  let notBoth = object ["not" .= object ["required" .= [String "a", String "b"]]]
  holds notBoth (object ["a" .= True])
  refuses notBoth (object ["a" .= True, "b" .= Null])
  let named = object ["type" .= String "object", "propertyNames" .= object ["pattern" .= String "^x+$"]]
  holds named (object ["xx" .= True])
  refuses named (object ["y" .= True])
  let nonEmpty = object ["type" .= String "object", "minProperties" .= (1 :: Int)]
  holds nonEmpty (object ["a" .= True])
  refuses nonEmpty (object [])

  require "unknown named schema accepted" (isLeft (validateNamed definitions "Missing" Null))
  let enclosing = Map.insert "Enclosing" record definitions
  require "declared property refused" (validateProperty enclosing "Enclosing" "a" (String "value") == Right ())
  require "invalid property accepted" (isLeft (validateProperty enclosing "Enclosing" "a" (Bool True)))
  require "absent enclosing schema accepted" (isLeft (validateProperty enclosing "Missing" "a" Null))
  require "absent property accepted" (isLeft (validateProperty enclosing "Enclosing" "missing" Null))
  require "propertyless schema accepted" (isLeft (validateProperty enclosing "Text" "a" Null))
  putStrLn "PASS schema refusal boundaries, unions and Unicode lengths"
  where
    ref :: Text -> Value
    ref name = object ["$ref" .= (name <> ".json")]
    toArray :: [Value] -> Value
    toArray = toJSON
