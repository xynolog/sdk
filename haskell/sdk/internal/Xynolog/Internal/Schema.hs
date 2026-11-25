{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Schema
  ( Schemas,
    checkSchema,
    matchesPattern,
    validate,
    validateNamed,
    validateProperty,
  )
where

import Control.Monad (forM_, unless, when)
import Data.Aeson (Object, Value (..))
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.Char (GeneralCategory (LineSeparator, ParagraphSeparator, Space), generalCategory, isUpper, toLower)
import Data.Foldable (toList)
import Data.List (nub)
import Data.Map.Strict (Map)
import Data.Map.Strict qualified as Map
import Data.Scientific (Scientific, floatingOrInteger)
import Data.Text (Text)
import Data.Text qualified as T
import Data.Vector qualified as V
import Text.Regex.TDFA (Regex, defaultCompOpt, defaultExecOpt, makeRegexOptsM, matchTest, multiline)

type Schemas = Map Text Value

ensure :: Bool -> String -> Either String ()
ensure good reason = unless good (Left reason)

objectFields :: Value -> Either String Object
objectFields (Object value) = Right value
objectFields _ = Left "expected a schema object"

reference :: Schemas -> Text -> Either String Value
reference schemas name =
  maybe
    (Left ("unknown schema reference: " ++ T.unpack name))
    Right
    (Map.lookup (T.dropEnd 5 (lastPart name)) schemas)
  where
    lastPart = T.takeWhileEnd (/= '/')

patternText :: Text -> Either String String
patternText = translate False . T.unpack
  where
    translate _ [] = Right []
    translate inside ('\\' : character : rest)
      | Just members <- lookup character classes = ((if inside then members else "[" ++ members ++ "]") ++) <$> translate inside rest
      | not inside, Just members <- lookup (toLower character) classes, isUpper character = (("[^" ++ members ++ "]") ++) <$> translate False rest
      | character `elem` ("^$.[]-+?*{}()|\\" :: String) = (['\\', character] ++) <$> translate inside rest
      | character `elem` ("/:" :: String) = ([character] ++) <$> translate inside rest
      | otherwise = Left ("unsupported regular-expression escape: \\" ++ [character])
    translate _ ('\\' : []) = Left "unterminated regular-expression escape"
    translate False ('[' : rest) = ('[' :) <$> translate True rest
    translate True (']' : rest) = (']' :) <$> translate False rest
    translate False ('.' : rest) = ("[^\n\r\x2028\x2029]" ++) <$> translate False rest
    translate inside (character : rest) = (character :) <$> translate inside rest

-- The members of each class escape ECMAScript states; its capital is the complement.
classes :: [(Char, String)]
classes = [('s', ecmaWhitespace), ('d', "0-9"), ('w', "A-Za-z0-9_")]

-- ECMAScript uses Unicode separator categories plus these control characters and BOM.
-- POSIX [:space:] in regex-tdfa is ASCII-only.
ecmaWhitespace :: String
ecmaWhitespace =
  "\t\n\v\f\r\xfeff"
    ++ filter
      (\character -> generalCategory character `elem` [Space, LineSeparator, ParagraphSeparator])
      [minBound .. maxBound]

compilePattern :: Text -> Either String Regex
compilePattern value = do
  expression <- patternText value
  maybe
    (Left ("unsupported regular expression: " ++ T.unpack value))
    Right
    (makeRegexOptsM defaultCompOpt {multiline = False} defaultExecOpt expression :: Maybe Regex)

-- | Whether @text@ matches the pattern @expression@ as Protocol states it.
matchesPattern :: Text -> Text -> Either String Bool
matchesPattern expression text = (`matchTest` T.unpack text) <$> compilePattern expression

-- Check every schema node the SDK validates against; annotation values are not schemas.
-- The generator writes each with its allOf merged, so a schema that states one is unsupported.
checkSchema :: Schemas -> Value -> Either String ()
checkSchema schemas schema = do
  fields <- objectFields schema
  forM_ (KM.keys fields) $ \key ->
    ensure
      (Key.toText key `elem` keywords)
      ("unsupported schema keyword: " ++ show key)
  case KM.lookup "$ref" fields of
    Nothing -> pure ()
    Just (String name) -> reference schemas name >> pure ()
    Just _ -> Left "$ref is not a string"
  case KM.lookup "type" fields of
    Nothing -> pure ()
    Just (String name) -> knownType name
    Just (Array names)
      | [String name, String "null"] <- toList names, name /= "null" -> knownType name
    Just _ -> Left "schema type is a name, or a name and null"
  case KM.lookup "format" fields of
    Nothing -> pure ()
    Just (String name) -> ensure (name `elem` ["uri", "date-time", "binary"]) ("unsupported format: " ++ T.unpack name)
    Just _ -> Left "format is not a string"
  case KM.lookup "pattern" fields of
    Nothing -> pure ()
    Just (String expression) -> compilePattern expression >> pure ()
    Just _ -> Left "pattern is not a string"
  forM_ ["minimum", "maximum"] $ \key -> case KM.lookup key fields of
    Nothing -> pure ()
    Just (Number _) -> pure ()
    Just _ -> Left (show key ++ " must be a number")
  forM_ ["minLength", "maxLength", "minItems", "maxItems", "minProperties", "maxProperties"] $ \key -> case KM.lookup key fields of
    Nothing -> pure ()
    Just (Number number) -> case floatingOrInteger number :: Either Double Integer of
      Right count -> ensure (count >= 0) (show key ++ " must be non-negative")
      Left _ -> Left (show key ++ " must be a whole number")
    Just _ -> Left (show key ++ " must be a whole number")
  forM_ ["uniqueItems", "deprecated", "readOnly", "writeOnly"] $ \key -> case KM.lookup key fields of
    Nothing -> pure ()
    Just (Bool _) -> pure ()
    Just _ -> Left (show key ++ " must be a boolean")
  case KM.lookup "required" fields of
    Nothing -> pure ()
    Just (Array names) -> forM_ names $ \name -> case name of String _ -> pure (); _ -> Left "required must contain strings"
    Just _ -> Left "required must be an array"
  case KM.lookup "enum" fields of
    Nothing -> pure ()
    Just (Array values) -> ensure (not (V.null values) && length (nub (toList values)) == V.length values) "enum must be non-empty and unique"
    Just _ -> Left "enum must be an array"
  case KM.lookup "properties" fields of
    Nothing -> pure ()
    Just (Object properties) -> mapM_ (checkSchema schemas) properties
    Just _ -> Left "properties is not an object"
  forM_ ["items", "additionalProperties", "propertyNames", "not"] $ \key -> case KM.lookup key fields of
    Nothing -> pure ()
    Just (Bool _) | key == "additionalProperties" -> pure ()
    Just value -> checkSchema schemas value
  forM_ ["oneOf", "anyOf"] $ \key -> case KM.lookup key fields of
    Nothing -> pure ()
    Just (Array values) -> ensure (not (V.null values)) "empty union" >> mapM_ (checkSchema schemas) values
    Just _ -> Left "union is not an array"
  where
    knownType name =
      ensure
        (name `elem` ["string", "integer", "number", "boolean", "object", "array", "null"])
        ("unsupported schema type: " ++ T.unpack name)
    keywords =
      [ "$ref",
        "$comment",
        "type",
        "description",
        "title",
        "properties",
        "required",
        "additionalProperties",
        "items",
        "enum",
        "const",
        "not",
        "propertyNames",
        "oneOf",
        "anyOf",
        "format",
        "pattern",
        "minimum",
        "maximum",
        "minLength",
        "maxLength",
        "minItems",
        "maxItems",
        "uniqueItems",
        "minProperties",
        "maxProperties",
        "default",
        "examples",
        "discriminator",
        "deprecated",
        "readOnly",
        "writeOnly"
      ]

validateNamed :: Schemas -> Text -> Value -> Either String ()
validateNamed schemas name value = case Map.lookup name schemas of
  Nothing -> Left ("unknown schema: " ++ T.unpack name)
  Just schema -> validate schemas schema value

validateProperty :: Schemas -> Text -> Key.Key -> Value -> Either String ()
validateProperty schemas named key value = do
  schema <- maybe (Left "unknown enclosing schema") Right (Map.lookup named schemas)
  fields <- objectFields schema
  properties <- maybe (Left "schema declares no properties") objectFields (KM.lookup "properties" fields)
  member <- maybe (Left "schema does not declare this property") Right (KM.lookup key properties)
  validate schemas member value

validate :: Schemas -> Value -> Value -> Either String ()
validate schemas original value = do
  schema <- objectFields original
  case KM.lookup "type" schema of
    Just (Array names)
      | [declared, String "null"] <- toList names ->
          if value == Null then pure () else validate schemas (Object (KM.insert "type" declared schema)) value
    _ -> do
      case KM.lookup "$ref" schema of
        Just (String name) -> reference schemas name >>= \target -> validate schemas target value
        _ -> pure ()
      case KM.lookup "enum" schema of
        Just (Array values) -> ensure (value `V.elem` values) "unknown enumeration member"
        _ -> pure ()
      case KM.lookup "const" schema of
        Just constant -> ensure (value == constant) "not the constant value"
        Nothing -> pure ()
      forM_ ["oneOf", "anyOf"] $ \key -> case KM.lookup key schema of
        Just (Array alternatives) -> do
          let accepted = V.length (V.filter (\branch -> either (const False) (const True) (validate schemas branch value)) alternatives)
          ensure
            (if key == "oneOf" then accepted == 1 else accepted > 0)
            (T.unpack (Key.toText key) ++ " rejected value (matched " ++ show accepted ++ " branches)")
        _ -> pure ()
      case KM.lookup "not" schema of
        Just refused -> ensure (either (const True) (const False) (validate schemas refused value)) "value matches a schema it must not"
        Nothing -> pure ()
      case KM.lookup "type" schema of
        Just (String name) -> ensure (admits name value) ("expected " ++ T.unpack name)
        Nothing -> pure ()
        _ -> Left "unsupported schema type"
      case value of
        String text -> do
          lengthBounds schema "minLength" "maxLength" (T.length text)
          case KM.lookup "pattern" schema of
            Just (String expression) -> do
              matched <- matchesPattern expression text
              ensure matched "string does not match pattern"
            _ -> pure ()
        Number number -> numberBounds schema number
        Array items -> do
          lengthBounds schema "minItems" "maxItems" (V.length items)
          when
            (KM.lookup "uniqueItems" schema == Just (Bool True))
            (ensure (length (nub (toList items)) == V.length items) "duplicate array item")
          case KM.lookup "items" schema of
            Just itemSchema -> mapM_ (validate schemas itemSchema) items
            Nothing -> ensure (KM.lookup "type" schema /= Just (String "array")) "array schema has no items"
        Object fields -> do
          lengthBounds schema "minProperties" "maxProperties" (KM.size fields)
          let properties = case KM.lookup "properties" schema of Just (Object p) -> p; _ -> KM.empty
          case KM.lookup "required" schema of
            Just (Array required) -> forM_ required $ \key -> case key of
              String name -> ensure (KM.member (Key.fromText name) fields) ("missing required field: " ++ T.unpack name)
              _ -> Left "required field is not a string"
            _ -> pure ()
          forM_ (KM.toList fields) $ \(key, member) -> do
            case KM.lookup "propertyNames" schema of
              Just names -> either (Left . ((show key ++ ": ") ++)) Right (validate schemas names (String (Key.toText key)))
              Nothing -> pure ()
            case KM.lookup key properties of
              Just fieldSchema -> either (Left . ((show key ++ ": ") ++)) Right (validate schemas fieldSchema member)
              Nothing -> case KM.lookup "additionalProperties" schema of
                Just (Bool False) -> Left ("unknown object field: " ++ show key)
                Just extra@(Object _) -> validate schemas extra member
                _ -> pure ()
        _ -> pure ()

-- Whether [value] is of the JSON Schema type [name].
admits :: Text -> Value -> Bool
admits "string" (String _) = True
admits "integer" (Number number) = either (const False :: Double -> Bool) (const True :: Integer -> Bool) (floatingOrInteger number)
admits "number" (Number _) = True
admits "boolean" (Bool _) = True
admits "null" Null = True
admits "array" (Array _) = True
admits "object" (Object _) = True
admits _ _ = False

lengthBounds :: Object -> Key.Key -> Key.Key -> Int -> Either String ()
lengthBounds schema low high size = do
  case KM.lookup low schema of { Just (Number bound) -> ensure (fromIntegral size >= bound) "value is too short"; _ -> pure () }
  case KM.lookup high schema of { Just (Number bound) -> ensure (fromIntegral size <= bound) "value is too long"; _ -> pure () }

numberBounds :: Object -> Scientific -> Either String ()
numberBounds schema number = do
  case KM.lookup "minimum" schema of { Just (Number bound) -> ensure (number >= bound) "number below minimum"; _ -> pure () }
  case KM.lookup "maximum" schema of { Just (Number bound) -> ensure (number <= bound) "number above maximum"; _ -> pure () }
