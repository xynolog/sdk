-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceStep (ConformanceStep (..), ConformanceStepAbandon (..), ConformanceStepBackend (..), ConformanceStepBackendBackend (..), conformanceStepBackendBackendText, ConformanceStepCarried (..), ConformanceStepClaimed (..), ConformanceStepClosed (..), ConformanceStepCompletes (..), ConformanceStepDriver (..), ConformanceStepError (..), ConformanceStepFetches (..), ConformanceStepFetchesFetchesItem (..), ConformanceStepFrame (..), ConformanceStepFrames (..), ConformanceStepHolds (..), ConformanceStepLeave (..), ConformanceStepLet (..), ConformanceStepObserve (..), ConformanceStepObserveObserve (..), ConformanceStepProgress (..), ConformanceStepQuiet (..), ConformanceStepReaches (..), ConformanceStepRefused (..), ConformanceStepScopes (..), ConformanceStepSettles (..), ConformanceStepSettlesAbandoned (..), ConformanceStepSignalled (..), ConformanceStepStalled (..), ConformanceStepState (..), ConformanceStepStateState (..), conformanceStepStateStateText, ConformanceStepStays (..), ConformanceStepStaysStays (..), conformanceStepStaysStaysText, ConformanceStepWire (..), ConformanceStepWireAt (..), conformanceStepWireAtText) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceBusFetch
import Xynolog.Internal.Generated.Models.ConformanceHttpFetch

data ConformanceStep = ConformanceStepLet ConformanceStepLet | ConformanceStepDriver ConformanceStepDriver | ConformanceStepAbandon ConformanceStepAbandon | ConformanceStepSettles ConformanceStepSettles | ConformanceStepWire ConformanceStepWire | ConformanceStepCarried ConformanceStepCarried | ConformanceStepClosed ConformanceStepClosed | ConformanceStepProgress ConformanceStepProgress | ConformanceStepState ConformanceStepState | ConformanceStepStays ConformanceStepStays | ConformanceStepFrame ConformanceStepFrame | ConformanceStepFrames ConformanceStepFrames | ConformanceStepError ConformanceStepError | ConformanceStepBackend ConformanceStepBackend | ConformanceStepQuiet ConformanceStepQuiet | ConformanceStepObserve ConformanceStepObserve | ConformanceStepLeave ConformanceStepLeave | ConformanceStepReaches ConformanceStepReaches | ConformanceStepHolds ConformanceStepHolds | ConformanceStepCompletes ConformanceStepCompletes | ConformanceStepConformanceBusFetch ConformanceBusFetch | ConformanceStepConformanceHttpFetch ConformanceHttpFetch | ConformanceStepFetches ConformanceStepFetches | ConformanceStepScopes ConformanceStepScopes | ConformanceStepClaimed ConformanceStepClaimed | ConformanceStepRefused ConformanceStepRefused | ConformanceStepSignalled ConformanceStepSignalled | ConformanceStepStalled ConformanceStepStalled deriving (Eq, Show)

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

data ConformanceStepAbandon = MkConformanceStepAbandon
  { conformanceStepAbandonAbandon :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepAbandon where parseJSON = checked "ConformanceStepAbandon" $ withObject "ConformanceStepAbandon" (\fields -> MkConformanceStepAbandon <$> (fields .: "abandon"))

instance ToJSON ConformanceStepAbandon where toJSON value = Object (KM.fromList (concat [[("abandon", toJSON (conformanceStepAbandonAbandon value))]]))

data ConformanceStepBackend = MkConformanceStepBackend
  { conformanceStepBackendBackend :: ConformanceStepBackendBackend,
    conformanceStepBackendWith :: Maybe (KM.KeyMap Value)
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBackend where parseJSON = checked "ConformanceStepBackend" $ withObject "ConformanceStepBackend" (\fields -> MkConformanceStepBackend <$> (fields .: "backend") <*> optional fields "with")

instance ToJSON ConformanceStepBackend where toJSON value = Object (KM.fromList (concat [[("backend", toJSON (conformanceStepBackendBackend value))], optionalPair "with" (conformanceStepBackendWith value)]))

data ConformanceStepBackendBackend = ConformanceStepBackendBackendListen | ConformanceStepBackendBackendEmit | ConformanceStepBackendBackendRecord | ConformanceStepBackendBackendContent | ConformanceStepBackendBackendDescription | ConformanceStepBackendBackendAnnotations | ConformanceStepBackendBackendAnchoredText | ConformanceStepBackendBackendUploaded | ConformanceStepBackendBackendRefuse | ConformanceStepBackendBackendUnanswered | ConformanceStepBackendBackendAnswerLost | ConformanceStepBackendBackendHold | ConformanceStepBackendBackendRelease | ConformanceStepBackendBackendRechunk | ConformanceStepBackendBackendCarry | ConformanceStepBackendBackendCut | ConformanceStepBackendBackendDown | ConformanceStepBackendBackendUp | ConformanceStepBackendBackendArchivist deriving (Eq, Show)

instance FromJSON ConformanceStepBackendBackend where parseJSON = checked "ConformanceStepBackendBackend" $ \value -> if value == String "listen" then pure ConformanceStepBackendBackendListen else if value == String "emit" then pure ConformanceStepBackendBackendEmit else if value == String "record" then pure ConformanceStepBackendBackendRecord else if value == String "content" then pure ConformanceStepBackendBackendContent else if value == String "description" then pure ConformanceStepBackendBackendDescription else if value == String "annotations" then pure ConformanceStepBackendBackendAnnotations else if value == String "anchored-text" then pure ConformanceStepBackendBackendAnchoredText else if value == String "uploaded" then pure ConformanceStepBackendBackendUploaded else if value == String "refuse" then pure ConformanceStepBackendBackendRefuse else if value == String "unanswered" then pure ConformanceStepBackendBackendUnanswered else if value == String "answer-lost" then pure ConformanceStepBackendBackendAnswerLost else if value == String "hold" then pure ConformanceStepBackendBackendHold else if value == String "release" then pure ConformanceStepBackendBackendRelease else if value == String "rechunk" then pure ConformanceStepBackendBackendRechunk else if value == String "carry" then pure ConformanceStepBackendBackendCarry else if value == String "cut" then pure ConformanceStepBackendBackendCut else if value == String "down" then pure ConformanceStepBackendBackendDown else if value == String "up" then pure ConformanceStepBackendBackendUp else if value == String "archivist" then pure ConformanceStepBackendBackendArchivist else fail "unknown enumeration member"

instance ToJSON ConformanceStepBackendBackend where
  toJSON ConformanceStepBackendBackendListen = String "listen"
  toJSON ConformanceStepBackendBackendEmit = String "emit"
  toJSON ConformanceStepBackendBackendRecord = String "record"
  toJSON ConformanceStepBackendBackendContent = String "content"
  toJSON ConformanceStepBackendBackendDescription = String "description"
  toJSON ConformanceStepBackendBackendAnnotations = String "annotations"
  toJSON ConformanceStepBackendBackendAnchoredText = String "anchored-text"
  toJSON ConformanceStepBackendBackendUploaded = String "uploaded"
  toJSON ConformanceStepBackendBackendRefuse = String "refuse"
  toJSON ConformanceStepBackendBackendUnanswered = String "unanswered"
  toJSON ConformanceStepBackendBackendAnswerLost = String "answer-lost"
  toJSON ConformanceStepBackendBackendHold = String "hold"
  toJSON ConformanceStepBackendBackendRelease = String "release"
  toJSON ConformanceStepBackendBackendRechunk = String "rechunk"
  toJSON ConformanceStepBackendBackendCarry = String "carry"
  toJSON ConformanceStepBackendBackendCut = String "cut"
  toJSON ConformanceStepBackendBackendDown = String "down"
  toJSON ConformanceStepBackendBackendUp = String "up"
  toJSON ConformanceStepBackendBackendArchivist = String "archivist"

conformanceStepBackendBackendText :: ConformanceStepBackendBackend -> Text
conformanceStepBackendBackendText ConformanceStepBackendBackendListen = "listen"
conformanceStepBackendBackendText ConformanceStepBackendBackendEmit = "emit"
conformanceStepBackendBackendText ConformanceStepBackendBackendRecord = "record"
conformanceStepBackendBackendText ConformanceStepBackendBackendContent = "content"
conformanceStepBackendBackendText ConformanceStepBackendBackendDescription = "description"
conformanceStepBackendBackendText ConformanceStepBackendBackendAnnotations = "annotations"
conformanceStepBackendBackendText ConformanceStepBackendBackendAnchoredText = "anchored-text"
conformanceStepBackendBackendText ConformanceStepBackendBackendUploaded = "uploaded"
conformanceStepBackendBackendText ConformanceStepBackendBackendRefuse = "refuse"
conformanceStepBackendBackendText ConformanceStepBackendBackendUnanswered = "unanswered"
conformanceStepBackendBackendText ConformanceStepBackendBackendAnswerLost = "answer-lost"
conformanceStepBackendBackendText ConformanceStepBackendBackendHold = "hold"
conformanceStepBackendBackendText ConformanceStepBackendBackendRelease = "release"
conformanceStepBackendBackendText ConformanceStepBackendBackendRechunk = "rechunk"
conformanceStepBackendBackendText ConformanceStepBackendBackendCarry = "carry"
conformanceStepBackendBackendText ConformanceStepBackendBackendCut = "cut"
conformanceStepBackendBackendText ConformanceStepBackendBackendDown = "down"
conformanceStepBackendBackendText ConformanceStepBackendBackendUp = "up"
conformanceStepBackendBackendText ConformanceStepBackendBackendArchivist = "archivist"

data ConformanceStepCarried = MkConformanceStepCarried
  { conformanceStepCarriedCarried :: Text,
    conformanceStepCarriedIs :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepCarried where parseJSON = checked "ConformanceStepCarried" $ withObject "ConformanceStepCarried" (\fields -> MkConformanceStepCarried <$> (fields .: "carried") <*> (fields .: "is"))

instance ToJSON ConformanceStepCarried where toJSON value = Object (KM.fromList (concat [[("carried", toJSON (conformanceStepCarriedCarried value))], [("is", toJSON (conformanceStepCarriedIs value))]]))

data ConformanceStepClaimed = MkConformanceStepClaimed
  { conformanceStepClaimedClaimed :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepClaimed where parseJSON = checked "ConformanceStepClaimed" $ withObject "ConformanceStepClaimed" (\fields -> MkConformanceStepClaimed <$> (fields .: "claimed"))

instance ToJSON ConformanceStepClaimed where toJSON value = Object (KM.fromList (concat [[("claimed", toJSON (conformanceStepClaimedClaimed value))]]))

data ConformanceStepClosed = MkConformanceStepClosed
  { conformanceStepClosedClosed :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepClosed where parseJSON = checked "ConformanceStepClosed" $ withObject "ConformanceStepClosed" (\fields -> MkConformanceStepClosed <$> (fields .: "closed"))

instance ToJSON ConformanceStepClosed where toJSON value = Object (KM.fromList (concat [[("closed", toJSON (conformanceStepClosedClosed value))]]))

data ConformanceStepCompletes = MkConformanceStepCompletes
  { conformanceStepCompletesCompletes :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepCompletes where parseJSON = checked "ConformanceStepCompletes" $ withObject "ConformanceStepCompletes" (\fields -> MkConformanceStepCompletes <$> (fields .: "completes"))

instance ToJSON ConformanceStepCompletes where toJSON value = Object (KM.fromList (concat [[("completes", toJSON (conformanceStepCompletesCompletes value))]]))

data ConformanceStepDriver = MkConformanceStepDriver
  { conformanceStepDriverDriver :: Text,
    conformanceStepDriverWith :: Maybe (KM.KeyMap Value),
    conformanceStepDriverReturns :: Maybe Value,
    conformanceStepDriverFails :: Maybe Value,
    conformanceStepDriverAs :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepDriver where parseJSON = checked "ConformanceStepDriver" $ withObject "ConformanceStepDriver" (\fields -> MkConformanceStepDriver <$> (fields .: "driver") <*> optional fields "with" <*> optional fields "returns" <*> optional fields "fails" <*> optional fields "as")

instance ToJSON ConformanceStepDriver where toJSON value = Object (KM.fromList (concat [[("driver", toJSON (conformanceStepDriverDriver value))], optionalPair "with" (conformanceStepDriverWith value), optionalPair "returns" (conformanceStepDriverReturns value), optionalPair "fails" (conformanceStepDriverFails value), optionalPair "as" (conformanceStepDriverAs value)]))

data ConformanceStepError = MkConformanceStepError
  { conformanceStepErrorError :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepError where parseJSON = checked "ConformanceStepError" $ withObject "ConformanceStepError" (\fields -> MkConformanceStepError <$> (fields .: "error"))

instance ToJSON ConformanceStepError where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceStepErrorError value))]]))

data ConformanceStepFetches = MkConformanceStepFetches
  { conformanceStepFetchesFetches :: [ConformanceStepFetchesFetchesItem]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepFetches where parseJSON = checked "ConformanceStepFetches" $ withObject "ConformanceStepFetches" (\fields -> MkConformanceStepFetches <$> (fields .: "fetches"))

instance ToJSON ConformanceStepFetches where toJSON value = Object (KM.fromList (concat [[("fetches", toJSON (conformanceStepFetchesFetches value))]]))

data ConformanceStepFetchesFetchesItem = ConformanceStepFetchesFetchesItemConformanceBusFetch ConformanceBusFetch | ConformanceStepFetchesFetchesItemConformanceHttpFetch ConformanceHttpFetch deriving (Eq, Show)

instance FromJSON ConformanceStepFetchesFetchesItem where parseJSON = checked "ConformanceStepFetchesFetchesItem" $ \value -> (ConformanceStepFetchesFetchesItemConformanceBusFetch <$> parseJSON value) <|> (ConformanceStepFetchesFetchesItemConformanceHttpFetch <$> parseJSON value)

instance ToJSON ConformanceStepFetchesFetchesItem where
  toJSON (ConformanceStepFetchesFetchesItemConformanceBusFetch value) = toJSON value
  toJSON (ConformanceStepFetchesFetchesItemConformanceHttpFetch value) = toJSON value

data ConformanceStepFrame = MkConformanceStepFrame
  { conformanceStepFrameFrame :: Text,
    conformanceStepFrameIs :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepFrame where parseJSON = checked "ConformanceStepFrame" $ withObject "ConformanceStepFrame" (\fields -> MkConformanceStepFrame <$> (fields .: "frame") <*> (fields .: "is"))

instance ToJSON ConformanceStepFrame where toJSON value = Object (KM.fromList (concat [[("frame", toJSON (conformanceStepFrameFrame value))], [("is", toJSON (conformanceStepFrameIs value))]]))

data ConformanceStepFrames = MkConformanceStepFrames
  { conformanceStepFramesFrames :: Text,
    conformanceStepFramesCount :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepFrames where parseJSON = checked "ConformanceStepFrames" $ withObject "ConformanceStepFrames" (\fields -> MkConformanceStepFrames <$> (fields .: "frames") <*> (fields .: "count"))

instance ToJSON ConformanceStepFrames where toJSON value = Object (KM.fromList (concat [[("frames", toJSON (conformanceStepFramesFrames value))], [("count", toJSON (conformanceStepFramesCount value))]]))

data ConformanceStepHolds = MkConformanceStepHolds
  { conformanceStepHoldsHolds :: Text,
    conformanceStepHoldsState :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepHolds where parseJSON = checked "ConformanceStepHolds" $ withObject "ConformanceStepHolds" (\fields -> MkConformanceStepHolds <$> (fields .: "holds") <*> (fields .: "state"))

instance ToJSON ConformanceStepHolds where toJSON value = Object (KM.fromList (concat [[("holds", toJSON (conformanceStepHoldsHolds value))], [("state", toJSON (conformanceStepHoldsState value))]]))

data ConformanceStepLeave = MkConformanceStepLeave
  { conformanceStepLeaveLeave :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepLeave where parseJSON = checked "ConformanceStepLeave" $ withObject "ConformanceStepLeave" (\fields -> MkConformanceStepLeave <$> (fields .: "leave"))

instance ToJSON ConformanceStepLeave where toJSON value = Object (KM.fromList (concat [[("leave", toJSON (conformanceStepLeaveLeave value))]]))

data ConformanceStepLet = MkConformanceStepLet
  { conformanceStepLetLet :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepLet where parseJSON = checked "ConformanceStepLet" $ withObject "ConformanceStepLet" (\fields -> MkConformanceStepLet <$> (fields .: "let"))

instance ToJSON ConformanceStepLet where toJSON value = Object (KM.fromList (concat [[("let", toJSON (conformanceStepLetLet value))]]))

data ConformanceStepObserve = MkConformanceStepObserve
  { conformanceStepObserveObserve :: ConformanceStepObserveObserve,
    conformanceStepObserveAs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepObserve where parseJSON = checked "ConformanceStepObserve" $ withObject "ConformanceStepObserve" (\fields -> MkConformanceStepObserve <$> (fields .: "observe") <*> (fields .: "as"))

instance ToJSON ConformanceStepObserve where toJSON value = Object (KM.fromList (concat [[("observe", toJSON (conformanceStepObserveObserve value))], [("as", toJSON (conformanceStepObserveAs value))]]))

data ConformanceStepObserveObserve = ConformanceStepObserveObserve
  { conformanceStepObserveObserveQuery :: Text,
    conformanceStepObserveObserveResource :: Maybe Value,
    conformanceStepObserveObserveAnnotation :: Maybe Value,
    conformanceStepObserveObserveSearch :: Maybe Value,
    conformanceStepObserveObserveFilters :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepObserveObserve where parseJSON = checked "ConformanceStepObserveObserve" $ withObject "ConformanceStepObserveObserve" (\fields -> ConformanceStepObserveObserve <$> (fields .: "query") <*> optional fields "resource" <*> optional fields "annotation" <*> optional fields "search" <*> optional fields "filters")

instance ToJSON ConformanceStepObserveObserve where toJSON value = Object (KM.fromList (concat [[("query", toJSON (conformanceStepObserveObserveQuery value))], optionalPair "resource" (conformanceStepObserveObserveResource value), optionalPair "annotation" (conformanceStepObserveObserveAnnotation value), optionalPair "search" (conformanceStepObserveObserveSearch value), optionalPair "filters" (conformanceStepObserveObserveFilters value)]))

data ConformanceStepProgress = MkConformanceStepProgress
  { conformanceStepProgressProgress :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepProgress where parseJSON = checked "ConformanceStepProgress" $ withObject "ConformanceStepProgress" (\fields -> MkConformanceStepProgress <$> (fields .: "progress"))

instance ToJSON ConformanceStepProgress where toJSON value = Object (KM.fromList (concat [[("progress", toJSON (conformanceStepProgressProgress value))]]))

data ConformanceStepQuiet = MkConformanceStepQuiet
  { conformanceStepQuietQuiet :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepQuiet where parseJSON = checked "ConformanceStepQuiet" $ withObject "ConformanceStepQuiet" (\fields -> MkConformanceStepQuiet <$> (fields .: "quiet"))

instance ToJSON ConformanceStepQuiet where toJSON value = Object (KM.fromList (concat [[("quiet", toJSON (conformanceStepQuietQuiet value))]]))

data ConformanceStepReaches = MkConformanceStepReaches
  { conformanceStepReachesReaches :: Text,
    conformanceStepReachesState :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepReaches where parseJSON = checked "ConformanceStepReaches" $ withObject "ConformanceStepReaches" (\fields -> MkConformanceStepReaches <$> (fields .: "reaches") <*> (fields .: "state"))

instance ToJSON ConformanceStepReaches where toJSON value = Object (KM.fromList (concat [[("reaches", toJSON (conformanceStepReachesReaches value))], [("state", toJSON (conformanceStepReachesState value))]]))

data ConformanceStepRefused = MkConformanceStepRefused
  { conformanceStepRefusedRefused :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepRefused where parseJSON = checked "ConformanceStepRefused" $ withObject "ConformanceStepRefused" (\fields -> MkConformanceStepRefused <$> (fields .: "refused"))

instance ToJSON ConformanceStepRefused where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (conformanceStepRefusedRefused value))]]))

data ConformanceStepScopes = MkConformanceStepScopes
  { conformanceStepScopesScopes :: [Value]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepScopes where parseJSON = checked "ConformanceStepScopes" $ withObject "ConformanceStepScopes" (\fields -> MkConformanceStepScopes <$> (fields .: "scopes"))

instance ToJSON ConformanceStepScopes where toJSON value = Object (KM.fromList (concat [[("scopes", toJSON (conformanceStepScopesScopes value))]]))

data ConformanceStepSettles = MkConformanceStepSettles
  { conformanceStepSettlesSettles :: Text,
    conformanceStepSettlesReturns :: Maybe Value,
    conformanceStepSettlesFails :: Maybe Value,
    conformanceStepSettlesAbandoned :: Maybe ConformanceStepSettlesAbandoned
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepSettles where parseJSON = checked "ConformanceStepSettles" $ withObject "ConformanceStepSettles" (\fields -> MkConformanceStepSettles <$> (fields .: "settles") <*> optional fields "returns" <*> optional fields "fails" <*> optional fields "abandoned")

instance ToJSON ConformanceStepSettles where toJSON value = Object (KM.fromList (concat [[("settles", toJSON (conformanceStepSettlesSettles value))], optionalPair "returns" (conformanceStepSettlesReturns value), optionalPair "fails" (conformanceStepSettlesFails value), optionalPair "abandoned" (conformanceStepSettlesAbandoned value)]))

data ConformanceStepSettlesAbandoned = ConformanceStepSettlesAbandonedTrue deriving (Eq, Show)

instance FromJSON ConformanceStepSettlesAbandoned where parseJSON = checked "ConformanceStepSettlesAbandoned" $ \value -> if value == Bool True then pure ConformanceStepSettlesAbandonedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceStepSettlesAbandoned where toJSON ConformanceStepSettlesAbandonedTrue = Bool True

data ConformanceStepSignalled = MkConformanceStepSignalled
  { conformanceStepSignalledSignalled :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepSignalled where parseJSON = checked "ConformanceStepSignalled" $ withObject "ConformanceStepSignalled" (\fields -> MkConformanceStepSignalled <$> (fields .: "signalled"))

instance ToJSON ConformanceStepSignalled where toJSON value = Object (KM.fromList (concat [[("signalled", toJSON (conformanceStepSignalledSignalled value))]]))

data ConformanceStepStalled = MkConformanceStepStalled
  { conformanceStepStalledStalled :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepStalled where parseJSON = checked "ConformanceStepStalled" $ withObject "ConformanceStepStalled" (\fields -> MkConformanceStepStalled <$> (fields .: "stalled"))

instance ToJSON ConformanceStepStalled where toJSON value = Object (KM.fromList (concat [[("stalled", toJSON (conformanceStepStalledStalled value))]]))

data ConformanceStepState = MkConformanceStepState
  { conformanceStepStateState :: ConformanceStepStateState
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepState where parseJSON = checked "ConformanceStepState" $ withObject "ConformanceStepState" (\fields -> MkConformanceStepState <$> (fields .: "state"))

instance ToJSON ConformanceStepState where toJSON value = Object (KM.fromList (concat [[("state", toJSON (conformanceStepStateState value))]]))

data ConformanceStepStateState = ConformanceStepStateStateInitial | ConformanceStepStateStateConnecting | ConformanceStepStateStateOpen | ConformanceStepStateStateReconnecting | ConformanceStepStateStateDegraded | ConformanceStepStateStateUnauthenticated | ConformanceStepStateStateClosed deriving (Eq, Show)

instance FromJSON ConformanceStepStateState where parseJSON = checked "ConformanceStepStateState" $ \value -> if value == String "initial" then pure ConformanceStepStateStateInitial else if value == String "connecting" then pure ConformanceStepStateStateConnecting else if value == String "open" then pure ConformanceStepStateStateOpen else if value == String "reconnecting" then pure ConformanceStepStateStateReconnecting else if value == String "degraded" then pure ConformanceStepStateStateDegraded else if value == String "unauthenticated" then pure ConformanceStepStateStateUnauthenticated else if value == String "closed" then pure ConformanceStepStateStateClosed else fail "unknown enumeration member"

instance ToJSON ConformanceStepStateState where
  toJSON ConformanceStepStateStateInitial = String "initial"
  toJSON ConformanceStepStateStateConnecting = String "connecting"
  toJSON ConformanceStepStateStateOpen = String "open"
  toJSON ConformanceStepStateStateReconnecting = String "reconnecting"
  toJSON ConformanceStepStateStateDegraded = String "degraded"
  toJSON ConformanceStepStateStateUnauthenticated = String "unauthenticated"
  toJSON ConformanceStepStateStateClosed = String "closed"

conformanceStepStateStateText :: ConformanceStepStateState -> Text
conformanceStepStateStateText ConformanceStepStateStateInitial = "initial"
conformanceStepStateStateText ConformanceStepStateStateConnecting = "connecting"
conformanceStepStateStateText ConformanceStepStateStateOpen = "open"
conformanceStepStateStateText ConformanceStepStateStateReconnecting = "reconnecting"
conformanceStepStateStateText ConformanceStepStateStateDegraded = "degraded"
conformanceStepStateStateText ConformanceStepStateStateUnauthenticated = "unauthenticated"
conformanceStepStateStateText ConformanceStepStateStateClosed = "closed"

data ConformanceStepStays = MkConformanceStepStays
  { conformanceStepStaysStays :: ConformanceStepStaysStays
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepStays where parseJSON = checked "ConformanceStepStays" $ withObject "ConformanceStepStays" (\fields -> MkConformanceStepStays <$> (fields .: "stays"))

instance ToJSON ConformanceStepStays where toJSON value = Object (KM.fromList (concat [[("stays", toJSON (conformanceStepStaysStays value))]]))

data ConformanceStepStaysStays = ConformanceStepStaysStaysInitial | ConformanceStepStaysStaysConnecting | ConformanceStepStaysStaysOpen | ConformanceStepStaysStaysReconnecting | ConformanceStepStaysStaysDegraded | ConformanceStepStaysStaysUnauthenticated | ConformanceStepStaysStaysClosed deriving (Eq, Show)

instance FromJSON ConformanceStepStaysStays where parseJSON = checked "ConformanceStepStaysStays" $ \value -> if value == String "initial" then pure ConformanceStepStaysStaysInitial else if value == String "connecting" then pure ConformanceStepStaysStaysConnecting else if value == String "open" then pure ConformanceStepStaysStaysOpen else if value == String "reconnecting" then pure ConformanceStepStaysStaysReconnecting else if value == String "degraded" then pure ConformanceStepStaysStaysDegraded else if value == String "unauthenticated" then pure ConformanceStepStaysStaysUnauthenticated else if value == String "closed" then pure ConformanceStepStaysStaysClosed else fail "unknown enumeration member"

instance ToJSON ConformanceStepStaysStays where
  toJSON ConformanceStepStaysStaysInitial = String "initial"
  toJSON ConformanceStepStaysStaysConnecting = String "connecting"
  toJSON ConformanceStepStaysStaysOpen = String "open"
  toJSON ConformanceStepStaysStaysReconnecting = String "reconnecting"
  toJSON ConformanceStepStaysStaysDegraded = String "degraded"
  toJSON ConformanceStepStaysStaysUnauthenticated = String "unauthenticated"
  toJSON ConformanceStepStaysStaysClosed = String "closed"

conformanceStepStaysStaysText :: ConformanceStepStaysStays -> Text
conformanceStepStaysStaysText ConformanceStepStaysStaysInitial = "initial"
conformanceStepStaysStaysText ConformanceStepStaysStaysConnecting = "connecting"
conformanceStepStaysStaysText ConformanceStepStaysStaysOpen = "open"
conformanceStepStaysStaysText ConformanceStepStaysStaysReconnecting = "reconnecting"
conformanceStepStaysStaysText ConformanceStepStaysStaysDegraded = "degraded"
conformanceStepStaysStaysText ConformanceStepStaysStaysUnauthenticated = "unauthenticated"
conformanceStepStaysStaysText ConformanceStepStaysStaysClosed = "closed"

data ConformanceStepWire = MkConformanceStepWire
  { conformanceStepWireWire :: Text,
    conformanceStepWireAt :: Maybe ConformanceStepWireAt,
    conformanceStepWireStatus :: Maybe Integer,
    conformanceStepWireParams :: Maybe Value,
    conformanceStepWireBody :: Maybe Value,
    conformanceStepWireToken :: Maybe Value,
    conformanceStepWireHeaders :: Maybe (KM.KeyMap Value),
    conformanceStepWireAnswer :: Maybe Value,
    conformanceStepWireAs :: Maybe Text,
    conformanceStepWireFollows :: Maybe Text,
    conformanceStepWireWaited :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepWire where parseJSON = checked "ConformanceStepWire" $ withObject "ConformanceStepWire" (\fields -> MkConformanceStepWire <$> (fields .: "wire") <*> optional fields "at" <*> optional fields "status" <*> optional fields "params" <*> optional fields "body" <*> optional fields "token" <*> optional fields "headers" <*> optional fields "answer" <*> optional fields "as" <*> optional fields "follows" <*> optional fields "waited")

instance ToJSON ConformanceStepWire where toJSON value = Object (KM.fromList (concat [[("wire", toJSON (conformanceStepWireWire value))], optionalPair "at" (conformanceStepWireAt value), optionalPair "status" (conformanceStepWireStatus value), optionalPair "params" (conformanceStepWireParams value), optionalPair "body" (conformanceStepWireBody value), optionalPair "token" (conformanceStepWireToken value), optionalPair "headers" (conformanceStepWireHeaders value), optionalPair "answer" (conformanceStepWireAnswer value), optionalPair "as" (conformanceStepWireAs value), optionalPair "follows" (conformanceStepWireFollows value), optionalPair "waited" (conformanceStepWireWaited value)]))

data ConformanceStepWireAt = ConformanceStepWireAtArrival | ConformanceStepWireAtAnswer | ConformanceStepWireAtLive deriving (Eq, Show)

instance FromJSON ConformanceStepWireAt where parseJSON = checked "ConformanceStepWireAt" $ \value -> if value == String "arrival" then pure ConformanceStepWireAtArrival else if value == String "answer" then pure ConformanceStepWireAtAnswer else if value == String "live" then pure ConformanceStepWireAtLive else fail "unknown enumeration member"

instance ToJSON ConformanceStepWireAt where
  toJSON ConformanceStepWireAtArrival = String "arrival"
  toJSON ConformanceStepWireAtAnswer = String "answer"
  toJSON ConformanceStepWireAtLive = String "live"

conformanceStepWireAtText :: ConformanceStepWireAt -> Text
conformanceStepWireAtText ConformanceStepWireAtArrival = "arrival"
conformanceStepWireAtText ConformanceStepWireAtAnswer = "answer"
conformanceStepWireAtText ConformanceStepWireAtLive = "live"
