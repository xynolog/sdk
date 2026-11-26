{-# LANGUAGE RankNTypes #-}

module Xynolog.Content (ContentTransport (..)) where

import Data.ByteString (ByteString)
import Data.Text (Text)
import Streaming (Of, Stream)
import Xynolog.Internal.Generated.OperationReports (UploadEvent)
import Xynolog.Types

-- An upload reports its body's size before any bytes are sent, how much is
-- sent as it goes, and the resource the gateway's answer names once it has
-- answered. An upload that fails reports no resource.
data ContentTransport = ContentTransport
  { putBinary :: Maybe Text -> PutBinaryRequest -> (UploadEvent -> IO ()) -> IO CreateResourceResponse,
    getBinary :: Maybe Text -> ResourceId -> IO ResourceRepresentation,
    getBinaryStream :: forall result. Maybe Text -> ResourceId -> (Text -> Stream (Of ByteString) IO () -> IO result) -> IO result,
    getResourceGraph :: Maybe Text -> ResourceId -> IO GetResourceResponse,
    getAnnotations :: Maybe Text -> ResourceId -> IO GetAnnotationsResponse,
    getAnchoredText :: Maybe Text -> ResourceId -> IO AnchoredTextAnswer,
    dispose :: IO ()
  }
