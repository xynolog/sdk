{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.StreamFrame (ReadFrame (..), readFrame) where

import Data.Aeson (Result (..), Value (..), eitherDecodeStrict', fromJSON)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (encodeUtf8)
import Xynolog.Internal.Required (faultOf, undecoded)
import Xynolog.Types (BusFrame, Fault (..), FrameRefusal (..))

data ReadFrame = Accepted BusFrame | Refused FrameRefusal | Rejected Fault deriving (Eq, Show)

readFrame :: Text -> ReadFrame
readFrame text = case eitherDecodeStrict' (encodeUtf8 text) of
  Left _ -> Rejected undecoded
  Right value -> case faultOf "BusFrame" value of
    Just issue -> refuse value issue
    Nothing -> case fromJSON value of
      Error _ -> refuse value undecoded
      Success frame -> Accepted frame
  where
    nonempty (Just (String value)) | not (Text.null value) = Just value
    nonempty _ = Nothing
    refuse (Object fields) issue
      | Just channel <- nonempty (KM.lookup "channel" fields),
        Just scope <- readScope (KM.lookup "scope" fields) =
          Refused
            ( FrameRefusal
                { frameRefusalChannel = channel,
                  frameRefusalMember = faultMember issue,
                  frameRefusalReason = faultReason issue,
                  frameRefusalPayload = KM.lookup "payload" fields,
                  frameRefusalScope = scope,
                  frameRefusalCorrelationId = nonempty (KM.lookup "correlationId" fields)
                }
            )
    refuse _ issue = Rejected issue
    readScope Nothing = Just Nothing
    readScope (Just value) = case fromJSON value of Error _ -> Nothing; Success scope -> Just (Just scope)
