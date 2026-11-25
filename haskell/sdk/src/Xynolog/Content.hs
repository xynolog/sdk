{-# LANGUAGE RankNTypes #-}

module Xynolog.Content (ContentTransport (..), ReplayableBody (..), bytesBody) where

import Data.ByteString (ByteString)
import Data.ByteString qualified as Bytes
import Data.IORef
import Data.Int (Int64)
import Data.Text (Text)
import Network.HTTP.Client (GivesPopper)
import Streaming (Of, Stream)
import Xynolog.Internal.Generated.OperationReports (UploadEvent)
import Xynolog.Types

-- The callback opens a fresh reader each time and releases it on return.
data ReplayableBody = ReplayableBody {bodyLength :: Maybe Int64, openBody :: GivesPopper ()}

bytesBody :: ByteString -> ReplayableBody
bytesBody bytes = ReplayableBody (Just (fromIntegral (Bytes.length bytes))) $ \consume -> do
  remaining <- newIORef bytes
  consume (atomicModifyIORef' remaining (\value -> (Bytes.empty, value)))

-- An upload reports its body's size before any bytes are sent, how much is
-- sent as it goes, and the resource the gateway's answer names once it has
-- answered. An upload that fails reports no resource.
data ContentTransport = ContentTransport
  { putBinary :: Maybe Text -> ResourceUploadMetadata -> ReplayableBody -> (UploadEvent -> IO ()) -> IO CreateResourceResponse,
    getBinary :: Maybe Text -> ResourceId -> IO ResourceRepresentation,
    getBinaryStream :: forall result. Maybe Text -> ResourceId -> (Text -> Stream (Of ByteString) IO () -> IO result) -> IO result,
    getResourceGraph :: Maybe Text -> ResourceId -> IO GetResourceResponse,
    getAnnotations :: Maybe Text -> ResourceId -> IO GetAnnotationsResponse,
    getAnchoredText :: Maybe Text -> ResourceId -> IO AnchoredTextAnswer,
    dispose :: IO ()
  }
