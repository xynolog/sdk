-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceStep (ConformanceStep (..), ConformanceStepAbandonValue (..), ConformanceStepBackendValue (..), ConformanceStepBackendValueBackend (..), conformanceStepBackendValueBackendText, ConformanceStepBackendValueWith (..), ConformanceStepCarriedValue (..), ConformanceStepClaimedValue (..), ConformanceStepClosedValue (..), ConformanceStepCompletesValue (..), ConformanceStepDriverValue (..), ConformanceStepDriverValueWith (..), ConformanceStepErrorValue (..), ConformanceStepFetchesValue (..), ConformanceStepFetchesValueFetchesItem (..), ConformanceStepFrameValue (..), ConformanceStepFramesValue (..), ConformanceStepHoldsValue (..), ConformanceStepLeaveValue (..), ConformanceStepLetValue (..), ConformanceStepLetValueLet (..), ConformanceStepObserveValue (..), ConformanceStepObserveValueObserve (..), ConformanceStepProgressValue (..), ConformanceStepQuietValue (..), ConformanceStepReachesValue (..), ConformanceStepRefusedValue (..), ConformanceStepScopesValue (..), ConformanceStepSettlesValue (..), ConformanceStepSettlesValueAbandoned (..), ConformanceStepSignalledValue (..), ConformanceStepStalledValue (..), ConformanceStepStateValue (..), ConformanceStepStateValueState (..), conformanceStepStateValueStateText, ConformanceStepStaysValue (..), ConformanceStepStaysValueStays (..), conformanceStepStaysValueStaysText, ConformanceStepWireValue (..), ConformanceStepWireValueAt (..), conformanceStepWireValueAtText, ConformanceStepWireValueHeaders (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceBusFetch
import Xynolog.Internal.Generated.Models.ConformanceHttpFetch

data ConformanceStep = ConformanceStepLet ConformanceStepLetValue | ConformanceStepDriver ConformanceStepDriverValue | ConformanceStepAbandon ConformanceStepAbandonValue | ConformanceStepSettles ConformanceStepSettlesValue | ConformanceStepWire ConformanceStepWireValue | ConformanceStepCarried ConformanceStepCarriedValue | ConformanceStepClosed ConformanceStepClosedValue | ConformanceStepProgress ConformanceStepProgressValue | ConformanceStepState ConformanceStepStateValue | ConformanceStepStays ConformanceStepStaysValue | ConformanceStepFrame ConformanceStepFrameValue | ConformanceStepFrames ConformanceStepFramesValue | ConformanceStepError ConformanceStepErrorValue | ConformanceStepBackend ConformanceStepBackendValue | ConformanceStepQuiet ConformanceStepQuietValue | ConformanceStepObserve ConformanceStepObserveValue | ConformanceStepLeave ConformanceStepLeaveValue | ConformanceStepReaches ConformanceStepReachesValue | ConformanceStepHolds ConformanceStepHoldsValue | ConformanceStepCompletes ConformanceStepCompletesValue | ConformanceStepConformanceBusFetch ConformanceBusFetch | ConformanceStepConformanceHttpFetch ConformanceHttpFetch | ConformanceStepFetches ConformanceStepFetchesValue | ConformanceStepScopes ConformanceStepScopesValue | ConformanceStepClaimed ConformanceStepClaimedValue | ConformanceStepRefused ConformanceStepRefusedValue | ConformanceStepSignalled ConformanceStepSignalledValue | ConformanceStepStalled ConformanceStepStalledValue deriving (Eq, Show)

instance FromJSON ConformanceStep where parseJSON = checked "ConformanceStep" $ \value -> (ConformanceStepLet <$> parseJSON value) <|> (ConformanceStepDriver <$> parseJSON value) <|> (ConformanceStepAbandon <$> parseJSON value) <|> (ConformanceStepSettles <$> parseJSON value) <|> (ConformanceStepWire <$> parseJSON value) <|> (ConformanceStepCarried <$> parseJSON value) <|> (ConformanceStepClosed <$> parseJSON value) <|> (ConformanceStepProgress <$> parseJSON value) <|> (ConformanceStepState <$> parseJSON value) <|> (ConformanceStepStays <$> parseJSON value) <|> (ConformanceStepFrame <$> parseJSON value) <|> (ConformanceStepFrames <$> parseJSON value) <|> (ConformanceStepError <$> parseJSON value) <|> (ConformanceStepBackend <$> parseJSON value) <|> (ConformanceStepQuiet <$> parseJSON value) <|> (ConformanceStepObserve <$> parseJSON value) <|> (ConformanceStepLeave <$> parseJSON value) <|> (ConformanceStepReaches <$> parseJSON value) <|> (ConformanceStepHolds <$> parseJSON value) <|> (ConformanceStepCompletes <$> parseJSON value) <|> (ConformanceStepConformanceBusFetch <$> parseJSON value) <|> (ConformanceStepConformanceHttpFetch <$> parseJSON value) <|> (ConformanceStepFetches <$> parseJSON value) <|> (ConformanceStepScopes <$> parseJSON value) <|> (ConformanceStepClaimed <$> parseJSON value) <|> (ConformanceStepRefused <$> parseJSON value) <|> (ConformanceStepSignalled <$> parseJSON value) <|> (ConformanceStepStalled <$> parseJSON value)

instance ToJSON ConformanceStep where
  toJSON (ConformanceStepLet value) = toJSON value
  toJSON (ConformanceStepDriver value) = toJSON value
  toJSON (ConformanceStepAbandon value) = toJSON value
  toJSON (ConformanceStepSettles value) = toJSON value
  toJSON (ConformanceStepWire value) = toJSON value
  toJSON (ConformanceStepCarried value) = toJSON value
  toJSON (ConformanceStepClosed value) = toJSON value
  toJSON (ConformanceStepProgress value) = toJSON value
  toJSON (ConformanceStepState value) = toJSON value
  toJSON (ConformanceStepStays value) = toJSON value
  toJSON (ConformanceStepFrame value) = toJSON value
  toJSON (ConformanceStepFrames value) = toJSON value
  toJSON (ConformanceStepError value) = toJSON value
  toJSON (ConformanceStepBackend value) = toJSON value
  toJSON (ConformanceStepQuiet value) = toJSON value
  toJSON (ConformanceStepObserve value) = toJSON value
  toJSON (ConformanceStepLeave value) = toJSON value
  toJSON (ConformanceStepReaches value) = toJSON value
  toJSON (ConformanceStepHolds value) = toJSON value
  toJSON (ConformanceStepCompletes value) = toJSON value
  toJSON (ConformanceStepConformanceBusFetch value) = toJSON value
  toJSON (ConformanceStepConformanceHttpFetch value) = toJSON value
  toJSON (ConformanceStepFetches value) = toJSON value
  toJSON (ConformanceStepScopes value) = toJSON value
  toJSON (ConformanceStepClaimed value) = toJSON value
  toJSON (ConformanceStepRefused value) = toJSON value
  toJSON (ConformanceStepSignalled value) = toJSON value
  toJSON (ConformanceStepStalled value) = toJSON value

data ConformanceStepAbandonValue = ConformanceStepAbandonValue
  { conformanceStepAbandonValueAbandon :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepAbandonValue where parseJSON = checked "ConformanceStepAbandonValue" $ withObject "ConformanceStepAbandonValue" (\fields -> ConformanceStepAbandonValue <$> (fields .: "abandon"))

instance ToJSON ConformanceStepAbandonValue where toJSON value = Object (KM.fromList (concat [[("abandon", toJSON (conformanceStepAbandonValueAbandon value))]]))

data ConformanceStepBackendValue = ConformanceStepBackendValue
  { conformanceStepBackendValueBackend :: ConformanceStepBackendValueBackend,
    conformanceStepBackendValueWith :: Maybe ConformanceStepBackendValueWith
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBackendValue where parseJSON = checked "ConformanceStepBackendValue" $ withObject "ConformanceStepBackendValue" (\fields -> ConformanceStepBackendValue <$> (fields .: "backend") <*> optional fields "with")

instance ToJSON ConformanceStepBackendValue where toJSON value = Object (KM.fromList (concat [[("backend", toJSON (conformanceStepBackendValueBackend value))], optionalPair "with" (conformanceStepBackendValueWith value)]))

data ConformanceStepBackendValueBackend = ConformanceStepBackendValueBackendListen | ConformanceStepBackendValueBackendEmit | ConformanceStepBackendValueBackendRecord | ConformanceStepBackendValueBackendContent | ConformanceStepBackendValueBackendDescription | ConformanceStepBackendValueBackendAnnotations | ConformanceStepBackendValueBackendAnchoredU2d_text | ConformanceStepBackendValueBackendUploaded | ConformanceStepBackendValueBackendRefuse | ConformanceStepBackendValueBackendUnanswered | ConformanceStepBackendValueBackendAnswerU2d_lost | ConformanceStepBackendValueBackendHold | ConformanceStepBackendValueBackendRelease | ConformanceStepBackendValueBackendRechunk | ConformanceStepBackendValueBackendCarry | ConformanceStepBackendValueBackendCut | ConformanceStepBackendValueBackendDown | ConformanceStepBackendValueBackendUp | ConformanceStepBackendValueBackendArchivist deriving (Eq, Show)

instance FromJSON ConformanceStepBackendValueBackend where parseJSON = checked "ConformanceStepBackendValueBackend" $ \value -> if value == String "listen" then pure ConformanceStepBackendValueBackendListen else if value == String "emit" then pure ConformanceStepBackendValueBackendEmit else if value == String "record" then pure ConformanceStepBackendValueBackendRecord else if value == String "content" then pure ConformanceStepBackendValueBackendContent else if value == String "description" then pure ConformanceStepBackendValueBackendDescription else if value == String "annotations" then pure ConformanceStepBackendValueBackendAnnotations else if value == String "anchored-text" then pure ConformanceStepBackendValueBackendAnchoredU2d_text else if value == String "uploaded" then pure ConformanceStepBackendValueBackendUploaded else if value == String "refuse" then pure ConformanceStepBackendValueBackendRefuse else if value == String "unanswered" then pure ConformanceStepBackendValueBackendUnanswered else if value == String "answer-lost" then pure ConformanceStepBackendValueBackendAnswerU2d_lost else if value == String "hold" then pure ConformanceStepBackendValueBackendHold else if value == String "release" then pure ConformanceStepBackendValueBackendRelease else if value == String "rechunk" then pure ConformanceStepBackendValueBackendRechunk else if value == String "carry" then pure ConformanceStepBackendValueBackendCarry else if value == String "cut" then pure ConformanceStepBackendValueBackendCut else if value == String "down" then pure ConformanceStepBackendValueBackendDown else if value == String "up" then pure ConformanceStepBackendValueBackendUp else if value == String "archivist" then pure ConformanceStepBackendValueBackendArchivist else fail "unknown enumeration member"

instance ToJSON ConformanceStepBackendValueBackend where
  toJSON ConformanceStepBackendValueBackendListen = String "listen"
  toJSON ConformanceStepBackendValueBackendEmit = String "emit"
  toJSON ConformanceStepBackendValueBackendRecord = String "record"
  toJSON ConformanceStepBackendValueBackendContent = String "content"
  toJSON ConformanceStepBackendValueBackendDescription = String "description"
  toJSON ConformanceStepBackendValueBackendAnnotations = String "annotations"
  toJSON ConformanceStepBackendValueBackendAnchoredU2d_text = String "anchored-text"
  toJSON ConformanceStepBackendValueBackendUploaded = String "uploaded"
  toJSON ConformanceStepBackendValueBackendRefuse = String "refuse"
  toJSON ConformanceStepBackendValueBackendUnanswered = String "unanswered"
  toJSON ConformanceStepBackendValueBackendAnswerU2d_lost = String "answer-lost"
  toJSON ConformanceStepBackendValueBackendHold = String "hold"
  toJSON ConformanceStepBackendValueBackendRelease = String "release"
  toJSON ConformanceStepBackendValueBackendRechunk = String "rechunk"
  toJSON ConformanceStepBackendValueBackendCarry = String "carry"
  toJSON ConformanceStepBackendValueBackendCut = String "cut"
  toJSON ConformanceStepBackendValueBackendDown = String "down"
  toJSON ConformanceStepBackendValueBackendUp = String "up"
  toJSON ConformanceStepBackendValueBackendArchivist = String "archivist"

conformanceStepBackendValueBackendText :: ConformanceStepBackendValueBackend -> Text
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendListen = "listen"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendEmit = "emit"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendRecord = "record"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendContent = "content"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendDescription = "description"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendAnnotations = "annotations"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendAnchoredU2d_text = "anchored-text"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendUploaded = "uploaded"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendRefuse = "refuse"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendUnanswered = "unanswered"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendAnswerU2d_lost = "answer-lost"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendHold = "hold"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendRelease = "release"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendRechunk = "rechunk"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendCarry = "carry"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendCut = "cut"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendDown = "down"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendUp = "up"
conformanceStepBackendValueBackendText ConformanceStepBackendValueBackendArchivist = "archivist"

data ConformanceStepBackendValueWith = ConformanceStepBackendValueWith
  { conformanceStepBackendValueWithAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBackendValueWith where parseJSON = checked "ConformanceStepBackendValueWith" $ withObject "ConformanceStepBackendValueWith" (\fields -> ConformanceStepBackendValueWith <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepBackendValueWith where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepBackendValueWithAdditionalProperties value)))

data ConformanceStepCarriedValue = ConformanceStepCarriedValue
  { conformanceStepCarriedValueCarried :: Text,
    conformanceStepCarriedValueIs :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepCarriedValue where parseJSON = checked "ConformanceStepCarriedValue" $ withObject "ConformanceStepCarriedValue" (\fields -> ConformanceStepCarriedValue <$> (fields .: "carried") <*> (fields .: "is"))

instance ToJSON ConformanceStepCarriedValue where toJSON value = Object (KM.fromList (concat [[("carried", toJSON (conformanceStepCarriedValueCarried value))], [("is", toJSON (conformanceStepCarriedValueIs value))]]))

data ConformanceStepClaimedValue = ConformanceStepClaimedValue
  { conformanceStepClaimedValueClaimed :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepClaimedValue where parseJSON = checked "ConformanceStepClaimedValue" $ withObject "ConformanceStepClaimedValue" (\fields -> ConformanceStepClaimedValue <$> (fields .: "claimed"))

instance ToJSON ConformanceStepClaimedValue where toJSON value = Object (KM.fromList (concat [[("claimed", toJSON (conformanceStepClaimedValueClaimed value))]]))

data ConformanceStepClosedValue = ConformanceStepClosedValue
  { conformanceStepClosedValueClosed :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepClosedValue where parseJSON = checked "ConformanceStepClosedValue" $ withObject "ConformanceStepClosedValue" (\fields -> ConformanceStepClosedValue <$> (fields .: "closed"))

instance ToJSON ConformanceStepClosedValue where toJSON value = Object (KM.fromList (concat [[("closed", toJSON (conformanceStepClosedValueClosed value))]]))

data ConformanceStepCompletesValue = ConformanceStepCompletesValue
  { conformanceStepCompletesValueCompletes :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepCompletesValue where parseJSON = checked "ConformanceStepCompletesValue" $ withObject "ConformanceStepCompletesValue" (\fields -> ConformanceStepCompletesValue <$> (fields .: "completes"))

instance ToJSON ConformanceStepCompletesValue where toJSON value = Object (KM.fromList (concat [[("completes", toJSON (conformanceStepCompletesValueCompletes value))]]))

data ConformanceStepDriverValue = ConformanceStepDriverValue
  { conformanceStepDriverValueAs :: Maybe Text,
    conformanceStepDriverValueDriver :: Text,
    conformanceStepDriverValueFails :: Maybe Value,
    conformanceStepDriverValueReturns :: Maybe Value,
    conformanceStepDriverValueWith :: Maybe ConformanceStepDriverValueWith
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepDriverValue where parseJSON = checked "ConformanceStepDriverValue" $ withObject "ConformanceStepDriverValue" (\fields -> ConformanceStepDriverValue <$> optional fields "as" <*> (fields .: "driver") <*> optional fields "fails" <*> optional fields "returns" <*> optional fields "with")

instance ToJSON ConformanceStepDriverValue where toJSON value = Object (KM.fromList (concat [optionalPair "as" (conformanceStepDriverValueAs value), [("driver", toJSON (conformanceStepDriverValueDriver value))], optionalPair "fails" (conformanceStepDriverValueFails value), optionalPair "returns" (conformanceStepDriverValueReturns value), optionalPair "with" (conformanceStepDriverValueWith value)]))

data ConformanceStepDriverValueWith = ConformanceStepDriverValueWith
  { conformanceStepDriverValueWithAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepDriverValueWith where parseJSON = checked "ConformanceStepDriverValueWith" $ withObject "ConformanceStepDriverValueWith" (\fields -> ConformanceStepDriverValueWith <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepDriverValueWith where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepDriverValueWithAdditionalProperties value)))

data ConformanceStepErrorValue = ConformanceStepErrorValue
  { conformanceStepErrorValueError :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepErrorValue where parseJSON = checked "ConformanceStepErrorValue" $ withObject "ConformanceStepErrorValue" (\fields -> ConformanceStepErrorValue <$> (fields .: "error"))

instance ToJSON ConformanceStepErrorValue where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceStepErrorValueError value))]]))

data ConformanceStepFetchesValue = ConformanceStepFetchesValue
  { conformanceStepFetchesValueFetches :: [ConformanceStepFetchesValueFetchesItem]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepFetchesValue where parseJSON = checked "ConformanceStepFetchesValue" $ withObject "ConformanceStepFetchesValue" (\fields -> ConformanceStepFetchesValue <$> (fields .: "fetches"))

instance ToJSON ConformanceStepFetchesValue where toJSON value = Object (KM.fromList (concat [[("fetches", toJSON (conformanceStepFetchesValueFetches value))]]))

data ConformanceStepFetchesValueFetchesItem = ConformanceStepFetchesValueFetchesItemConformanceBusFetch ConformanceBusFetch | ConformanceStepFetchesValueFetchesItemConformanceHttpFetch ConformanceHttpFetch deriving (Eq, Show)

instance FromJSON ConformanceStepFetchesValueFetchesItem where parseJSON = checked "ConformanceStepFetchesValueFetchesItem" $ \value -> (ConformanceStepFetchesValueFetchesItemConformanceBusFetch <$> parseJSON value) <|> (ConformanceStepFetchesValueFetchesItemConformanceHttpFetch <$> parseJSON value)

instance ToJSON ConformanceStepFetchesValueFetchesItem where
  toJSON (ConformanceStepFetchesValueFetchesItemConformanceBusFetch value) = toJSON value
  toJSON (ConformanceStepFetchesValueFetchesItemConformanceHttpFetch value) = toJSON value

data ConformanceStepFrameValue = ConformanceStepFrameValue
  { conformanceStepFrameValueFrame :: Text,
    conformanceStepFrameValueIs :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepFrameValue where parseJSON = checked "ConformanceStepFrameValue" $ withObject "ConformanceStepFrameValue" (\fields -> ConformanceStepFrameValue <$> (fields .: "frame") <*> (fields .: "is"))

instance ToJSON ConformanceStepFrameValue where toJSON value = Object (KM.fromList (concat [[("frame", toJSON (conformanceStepFrameValueFrame value))], [("is", toJSON (conformanceStepFrameValueIs value))]]))

data ConformanceStepFramesValue = ConformanceStepFramesValue
  { conformanceStepFramesValueCount :: Integer,
    conformanceStepFramesValueFrames :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepFramesValue where parseJSON = checked "ConformanceStepFramesValue" $ withObject "ConformanceStepFramesValue" (\fields -> ConformanceStepFramesValue <$> (fields .: "count") <*> (fields .: "frames"))

instance ToJSON ConformanceStepFramesValue where toJSON value = Object (KM.fromList (concat [[("count", toJSON (conformanceStepFramesValueCount value))], [("frames", toJSON (conformanceStepFramesValueFrames value))]]))

data ConformanceStepHoldsValue = ConformanceStepHoldsValue
  { conformanceStepHoldsValueHolds :: Text,
    conformanceStepHoldsValueState :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepHoldsValue where parseJSON = checked "ConformanceStepHoldsValue" $ withObject "ConformanceStepHoldsValue" (\fields -> ConformanceStepHoldsValue <$> (fields .: "holds") <*> (fields .: "state"))

instance ToJSON ConformanceStepHoldsValue where toJSON value = Object (KM.fromList (concat [[("holds", toJSON (conformanceStepHoldsValueHolds value))], [("state", toJSON (conformanceStepHoldsValueState value))]]))

data ConformanceStepLeaveValue = ConformanceStepLeaveValue
  { conformanceStepLeaveValueLeave :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepLeaveValue where parseJSON = checked "ConformanceStepLeaveValue" $ withObject "ConformanceStepLeaveValue" (\fields -> ConformanceStepLeaveValue <$> (fields .: "leave"))

instance ToJSON ConformanceStepLeaveValue where toJSON value = Object (KM.fromList (concat [[("leave", toJSON (conformanceStepLeaveValueLeave value))]]))

data ConformanceStepLetValue = ConformanceStepLetValue
  { conformanceStepLetValueLet :: ConformanceStepLetValueLet
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepLetValue where parseJSON = checked "ConformanceStepLetValue" $ withObject "ConformanceStepLetValue" (\fields -> ConformanceStepLetValue <$> (fields .: "let"))

instance ToJSON ConformanceStepLetValue where toJSON value = Object (KM.fromList (concat [[("let", toJSON (conformanceStepLetValueLet value))]]))

data ConformanceStepLetValueLet = ConformanceStepLetValueLet
  { conformanceStepLetValueLetAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepLetValueLet where parseJSON = checked "ConformanceStepLetValueLet" $ withObject "ConformanceStepLetValueLet" (\fields -> ConformanceStepLetValueLet <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepLetValueLet where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepLetValueLetAdditionalProperties value)))

data ConformanceStepObserveValue = ConformanceStepObserveValue
  { conformanceStepObserveValueAs :: Text,
    conformanceStepObserveValueObserve :: ConformanceStepObserveValueObserve
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepObserveValue where parseJSON = checked "ConformanceStepObserveValue" $ withObject "ConformanceStepObserveValue" (\fields -> ConformanceStepObserveValue <$> (fields .: "as") <*> (fields .: "observe"))

instance ToJSON ConformanceStepObserveValue where toJSON value = Object (KM.fromList (concat [[("as", toJSON (conformanceStepObserveValueAs value))], [("observe", toJSON (conformanceStepObserveValueObserve value))]]))

data ConformanceStepObserveValueObserve = ConformanceStepObserveValueObserve
  { conformanceStepObserveValueObserveAnnotation :: Maybe Value,
    conformanceStepObserveValueObserveFilters :: Maybe Value,
    conformanceStepObserveValueObserveQuery :: Text,
    conformanceStepObserveValueObserveResource :: Maybe Value,
    conformanceStepObserveValueObserveSearch :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepObserveValueObserve where parseJSON = checked "ConformanceStepObserveValueObserve" $ withObject "ConformanceStepObserveValueObserve" (\fields -> ConformanceStepObserveValueObserve <$> optional fields "annotation" <*> optional fields "filters" <*> (fields .: "query") <*> optional fields "resource" <*> optional fields "search")

instance ToJSON ConformanceStepObserveValueObserve where toJSON value = Object (KM.fromList (concat [optionalPair "annotation" (conformanceStepObserveValueObserveAnnotation value), optionalPair "filters" (conformanceStepObserveValueObserveFilters value), [("query", toJSON (conformanceStepObserveValueObserveQuery value))], optionalPair "resource" (conformanceStepObserveValueObserveResource value), optionalPair "search" (conformanceStepObserveValueObserveSearch value)]))

data ConformanceStepProgressValue = ConformanceStepProgressValue
  { conformanceStepProgressValueProgress :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepProgressValue where parseJSON = checked "ConformanceStepProgressValue" $ withObject "ConformanceStepProgressValue" (\fields -> ConformanceStepProgressValue <$> (fields .: "progress"))

instance ToJSON ConformanceStepProgressValue where toJSON value = Object (KM.fromList (concat [[("progress", toJSON (conformanceStepProgressValueProgress value))]]))

data ConformanceStepQuietValue = ConformanceStepQuietValue
  { conformanceStepQuietValueQuiet :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepQuietValue where parseJSON = checked "ConformanceStepQuietValue" $ withObject "ConformanceStepQuietValue" (\fields -> ConformanceStepQuietValue <$> (fields .: "quiet"))

instance ToJSON ConformanceStepQuietValue where toJSON value = Object (KM.fromList (concat [[("quiet", toJSON (conformanceStepQuietValueQuiet value))]]))

data ConformanceStepReachesValue = ConformanceStepReachesValue
  { conformanceStepReachesValueReaches :: Text,
    conformanceStepReachesValueState :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepReachesValue where parseJSON = checked "ConformanceStepReachesValue" $ withObject "ConformanceStepReachesValue" (\fields -> ConformanceStepReachesValue <$> (fields .: "reaches") <*> (fields .: "state"))

instance ToJSON ConformanceStepReachesValue where toJSON value = Object (KM.fromList (concat [[("reaches", toJSON (conformanceStepReachesValueReaches value))], [("state", toJSON (conformanceStepReachesValueState value))]]))

data ConformanceStepRefusedValue = ConformanceStepRefusedValue
  { conformanceStepRefusedValueRefused :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepRefusedValue where parseJSON = checked "ConformanceStepRefusedValue" $ withObject "ConformanceStepRefusedValue" (\fields -> ConformanceStepRefusedValue <$> (fields .: "refused"))

instance ToJSON ConformanceStepRefusedValue where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (conformanceStepRefusedValueRefused value))]]))

data ConformanceStepScopesValue = ConformanceStepScopesValue
  { conformanceStepScopesValueScopes :: [Value]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepScopesValue where parseJSON = checked "ConformanceStepScopesValue" $ withObject "ConformanceStepScopesValue" (\fields -> ConformanceStepScopesValue <$> (fields .: "scopes"))

instance ToJSON ConformanceStepScopesValue where toJSON value = Object (KM.fromList (concat [[("scopes", toJSON (conformanceStepScopesValueScopes value))]]))

data ConformanceStepSettlesValue = ConformanceStepSettlesValue
  { conformanceStepSettlesValueAbandoned :: Maybe ConformanceStepSettlesValueAbandoned,
    conformanceStepSettlesValueFails :: Maybe Value,
    conformanceStepSettlesValueReturns :: Maybe Value,
    conformanceStepSettlesValueSettles :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepSettlesValue where parseJSON = checked "ConformanceStepSettlesValue" $ withObject "ConformanceStepSettlesValue" (\fields -> ConformanceStepSettlesValue <$> optional fields "abandoned" <*> optional fields "fails" <*> optional fields "returns" <*> (fields .: "settles"))

instance ToJSON ConformanceStepSettlesValue where toJSON value = Object (KM.fromList (concat [optionalPair "abandoned" (conformanceStepSettlesValueAbandoned value), optionalPair "fails" (conformanceStepSettlesValueFails value), optionalPair "returns" (conformanceStepSettlesValueReturns value), [("settles", toJSON (conformanceStepSettlesValueSettles value))]]))

data ConformanceStepSettlesValueAbandoned = ConformanceStepSettlesValueAbandonedTrue deriving (Eq, Show)

instance FromJSON ConformanceStepSettlesValueAbandoned where parseJSON = checked "ConformanceStepSettlesValueAbandoned" $ \value -> if value == Bool True then pure ConformanceStepSettlesValueAbandonedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceStepSettlesValueAbandoned where toJSON ConformanceStepSettlesValueAbandonedTrue = Bool True

data ConformanceStepSignalledValue = ConformanceStepSignalledValue
  { conformanceStepSignalledValueSignalled :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepSignalledValue where parseJSON = checked "ConformanceStepSignalledValue" $ withObject "ConformanceStepSignalledValue" (\fields -> ConformanceStepSignalledValue <$> (fields .: "signalled"))

instance ToJSON ConformanceStepSignalledValue where toJSON value = Object (KM.fromList (concat [[("signalled", toJSON (conformanceStepSignalledValueSignalled value))]]))

data ConformanceStepStalledValue = ConformanceStepStalledValue
  { conformanceStepStalledValueStalled :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepStalledValue where parseJSON = checked "ConformanceStepStalledValue" $ withObject "ConformanceStepStalledValue" (\fields -> ConformanceStepStalledValue <$> (fields .: "stalled"))

instance ToJSON ConformanceStepStalledValue where toJSON value = Object (KM.fromList (concat [[("stalled", toJSON (conformanceStepStalledValueStalled value))]]))

data ConformanceStepStateValue = ConformanceStepStateValue
  { conformanceStepStateValueState :: ConformanceStepStateValueState
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepStateValue where parseJSON = checked "ConformanceStepStateValue" $ withObject "ConformanceStepStateValue" (\fields -> ConformanceStepStateValue <$> (fields .: "state"))

instance ToJSON ConformanceStepStateValue where toJSON value = Object (KM.fromList (concat [[("state", toJSON (conformanceStepStateValueState value))]]))

data ConformanceStepStateValueState = ConformanceStepStateValueStateInitial | ConformanceStepStateValueStateConnecting | ConformanceStepStateValueStateOpen | ConformanceStepStateValueStateReconnecting | ConformanceStepStateValueStateDegraded | ConformanceStepStateValueStateUnauthenticated | ConformanceStepStateValueStateClosed deriving (Eq, Show)

instance FromJSON ConformanceStepStateValueState where parseJSON = checked "ConformanceStepStateValueState" $ \value -> if value == String "initial" then pure ConformanceStepStateValueStateInitial else if value == String "connecting" then pure ConformanceStepStateValueStateConnecting else if value == String "open" then pure ConformanceStepStateValueStateOpen else if value == String "reconnecting" then pure ConformanceStepStateValueStateReconnecting else if value == String "degraded" then pure ConformanceStepStateValueStateDegraded else if value == String "unauthenticated" then pure ConformanceStepStateValueStateUnauthenticated else if value == String "closed" then pure ConformanceStepStateValueStateClosed else fail "unknown enumeration member"

instance ToJSON ConformanceStepStateValueState where
  toJSON ConformanceStepStateValueStateInitial = String "initial"
  toJSON ConformanceStepStateValueStateConnecting = String "connecting"
  toJSON ConformanceStepStateValueStateOpen = String "open"
  toJSON ConformanceStepStateValueStateReconnecting = String "reconnecting"
  toJSON ConformanceStepStateValueStateDegraded = String "degraded"
  toJSON ConformanceStepStateValueStateUnauthenticated = String "unauthenticated"
  toJSON ConformanceStepStateValueStateClosed = String "closed"

conformanceStepStateValueStateText :: ConformanceStepStateValueState -> Text
conformanceStepStateValueStateText ConformanceStepStateValueStateInitial = "initial"
conformanceStepStateValueStateText ConformanceStepStateValueStateConnecting = "connecting"
conformanceStepStateValueStateText ConformanceStepStateValueStateOpen = "open"
conformanceStepStateValueStateText ConformanceStepStateValueStateReconnecting = "reconnecting"
conformanceStepStateValueStateText ConformanceStepStateValueStateDegraded = "degraded"
conformanceStepStateValueStateText ConformanceStepStateValueStateUnauthenticated = "unauthenticated"
conformanceStepStateValueStateText ConformanceStepStateValueStateClosed = "closed"

data ConformanceStepStaysValue = ConformanceStepStaysValue
  { conformanceStepStaysValueStays :: ConformanceStepStaysValueStays
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepStaysValue where parseJSON = checked "ConformanceStepStaysValue" $ withObject "ConformanceStepStaysValue" (\fields -> ConformanceStepStaysValue <$> (fields .: "stays"))

instance ToJSON ConformanceStepStaysValue where toJSON value = Object (KM.fromList (concat [[("stays", toJSON (conformanceStepStaysValueStays value))]]))

data ConformanceStepStaysValueStays = ConformanceStepStaysValueStaysInitial | ConformanceStepStaysValueStaysConnecting | ConformanceStepStaysValueStaysOpen | ConformanceStepStaysValueStaysReconnecting | ConformanceStepStaysValueStaysDegraded | ConformanceStepStaysValueStaysUnauthenticated | ConformanceStepStaysValueStaysClosed deriving (Eq, Show)

instance FromJSON ConformanceStepStaysValueStays where parseJSON = checked "ConformanceStepStaysValueStays" $ \value -> if value == String "initial" then pure ConformanceStepStaysValueStaysInitial else if value == String "connecting" then pure ConformanceStepStaysValueStaysConnecting else if value == String "open" then pure ConformanceStepStaysValueStaysOpen else if value == String "reconnecting" then pure ConformanceStepStaysValueStaysReconnecting else if value == String "degraded" then pure ConformanceStepStaysValueStaysDegraded else if value == String "unauthenticated" then pure ConformanceStepStaysValueStaysUnauthenticated else if value == String "closed" then pure ConformanceStepStaysValueStaysClosed else fail "unknown enumeration member"

instance ToJSON ConformanceStepStaysValueStays where
  toJSON ConformanceStepStaysValueStaysInitial = String "initial"
  toJSON ConformanceStepStaysValueStaysConnecting = String "connecting"
  toJSON ConformanceStepStaysValueStaysOpen = String "open"
  toJSON ConformanceStepStaysValueStaysReconnecting = String "reconnecting"
  toJSON ConformanceStepStaysValueStaysDegraded = String "degraded"
  toJSON ConformanceStepStaysValueStaysUnauthenticated = String "unauthenticated"
  toJSON ConformanceStepStaysValueStaysClosed = String "closed"

conformanceStepStaysValueStaysText :: ConformanceStepStaysValueStays -> Text
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysInitial = "initial"
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysConnecting = "connecting"
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysOpen = "open"
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysReconnecting = "reconnecting"
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysDegraded = "degraded"
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysUnauthenticated = "unauthenticated"
conformanceStepStaysValueStaysText ConformanceStepStaysValueStaysClosed = "closed"

data ConformanceStepWireValue = ConformanceStepWireValue
  { conformanceStepWireValueAnswer :: Maybe Value,
    conformanceStepWireValueAs :: Maybe Text,
    conformanceStepWireValueAt :: Maybe ConformanceStepWireValueAt,
    conformanceStepWireValueBody :: Maybe Value,
    conformanceStepWireValueFollows :: Maybe Text,
    conformanceStepWireValueHeaders :: Maybe ConformanceStepWireValueHeaders,
    conformanceStepWireValueParams :: Maybe Value,
    conformanceStepWireValueStatus :: Maybe Integer,
    conformanceStepWireValueToken :: Maybe Value,
    conformanceStepWireValueWaited :: Maybe Text,
    conformanceStepWireValueWire :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepWireValue where parseJSON = checked "ConformanceStepWireValue" $ withObject "ConformanceStepWireValue" (\fields -> ConformanceStepWireValue <$> optional fields "answer" <*> optional fields "as" <*> optional fields "at" <*> optional fields "body" <*> optional fields "follows" <*> optional fields "headers" <*> optional fields "params" <*> optional fields "status" <*> optional fields "token" <*> optional fields "waited" <*> (fields .: "wire"))

instance ToJSON ConformanceStepWireValue where toJSON value = Object (KM.fromList (concat [optionalPair "answer" (conformanceStepWireValueAnswer value), optionalPair "as" (conformanceStepWireValueAs value), optionalPair "at" (conformanceStepWireValueAt value), optionalPair "body" (conformanceStepWireValueBody value), optionalPair "follows" (conformanceStepWireValueFollows value), optionalPair "headers" (conformanceStepWireValueHeaders value), optionalPair "params" (conformanceStepWireValueParams value), optionalPair "status" (conformanceStepWireValueStatus value), optionalPair "token" (conformanceStepWireValueToken value), optionalPair "waited" (conformanceStepWireValueWaited value), [("wire", toJSON (conformanceStepWireValueWire value))]]))

data ConformanceStepWireValueAt = ConformanceStepWireValueAtArrival | ConformanceStepWireValueAtAnswer | ConformanceStepWireValueAtLive deriving (Eq, Show)

instance FromJSON ConformanceStepWireValueAt where parseJSON = checked "ConformanceStepWireValueAt" $ \value -> if value == String "arrival" then pure ConformanceStepWireValueAtArrival else if value == String "answer" then pure ConformanceStepWireValueAtAnswer else if value == String "live" then pure ConformanceStepWireValueAtLive else fail "unknown enumeration member"

instance ToJSON ConformanceStepWireValueAt where
  toJSON ConformanceStepWireValueAtArrival = String "arrival"
  toJSON ConformanceStepWireValueAtAnswer = String "answer"
  toJSON ConformanceStepWireValueAtLive = String "live"

conformanceStepWireValueAtText :: ConformanceStepWireValueAt -> Text
conformanceStepWireValueAtText ConformanceStepWireValueAtArrival = "arrival"
conformanceStepWireValueAtText ConformanceStepWireValueAtAnswer = "answer"
conformanceStepWireValueAtText ConformanceStepWireValueAtLive = "live"

data ConformanceStepWireValueHeaders = ConformanceStepWireValueHeaders
  { conformanceStepWireValueHeadersAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepWireValueHeaders where parseJSON = checked "ConformanceStepWireValueHeaders" $ withObject "ConformanceStepWireValueHeaders" (\fields -> ConformanceStepWireValueHeaders <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepWireValueHeaders where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepWireValueHeadersAdditionalProperties value)))
