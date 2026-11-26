{-# LANGUAGE OverloadedStrings #-}

-- | A stand-in gateway and the issuer it trusts, over real http-client connections. The gateway says who a token is,
-- holds streams, and answers on every stream a request to describe the knowledge base and a request for a resource,
-- naming it fresh, as it answers a stream that names the request pending; the issuer grants what it is told to.
module GatewayStage (Stage (..), newStage, stageHttp, registered, signInOf, send, resumedFrom, resumedWith) where

import Control.Concurrent.STM
import Control.Monad (forM_)
import ControlledTime qualified as Time
import Data.Aeson (FromJSON, Result (..), Value (..), eitherDecodeStrict', encode, fromJSON, object, toJSON, (.=))
import Data.ByteString qualified as Bytes
import Data.ByteString.Char8 qualified as Char8
import Data.ByteString.Lazy qualified as Lazy
import Data.Char (toLower)
import Data.Map.Strict qualified as Map
import Data.Maybe (fromMaybe, listToMaybe, mapMaybe)
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8, encodeUtf8)
import Data.UUID.Types qualified as UUID
import Data.Word (Word32)
import IssuerCases (bodyOf, jsonReply, route, streamingPeer)
import Xynolog.Channels (Channel (..), channelName, decodePayload, encodePayload)
import Xynolog.Channels qualified as Channels
import Xynolog.Http qualified as Http
import Xynolog.Http.Routes (HttpRoute (..), routePath)
import Xynolog.Identity qualified as Identity
import Xynolog.Retry (RetryOptions (..))
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types hiding (BrowseKbResult, BrowseResourceResult)
import Xynolog.Types qualified as Types

data Stage = Stage
  { -- | What the gateway says every token is; Nothing gives no answer, the connection closed.
    stageWho :: TVar (Maybe Value),
    -- | While True, every answer of who a token is waits.
    stageWhoHeld :: TVar Bool,
    -- | The tokens the gateway refuses to say who they are.
    stageRefusesWho :: TVar (Set.Set Text),
    -- | The access and refresh tokens the issuer grants next, one pair each.
    stageGrants :: TVar [(Text, Text)],
    -- | Every token the gateway was asked who it is.
    stageAskedWho :: TVar [Text],
    -- | Every stream asked for.
    stageSubscriptions :: TVar [BusSubscribeRequest],
    stageStreams :: TVar [Bytes.ByteString -> STM ()],
    -- | Every reply sent, by its correlation id.
    stageReplies :: TVar (Map.Map Text Bytes.ByteString),
    -- | Every request the stage has no answer for.
    stageStrays :: TVar [Bytes.ByteString]
  }

newStage :: IO Stage
newStage =
  atomically $
    Stage
      <$> newTVar Nothing
      <*> newTVar False
      <*> newTVar Set.empty
      <*> newTVar []
      <*> newTVar []
      <*> newTVar []
      <*> newTVar []
      <*> newTVar Map.empty
      <*> newTVar []

-- | What reaches the stage: every request answered by it, the clock the controlled one, and the stream's global
-- channels the bus's. A session or the registry's factory replaces the token reader, the renewer and the base.
stageHttp :: Stage -> Time.ControlledTime -> Timing.Settings -> IO Http.HttpOptions
stageHttp stage time timing = do
  connections <- streamingPeer (answer stage)
  ids <- newTVarIO (0 :: Word32)
  pure
    ( Http.HttpOptions
        "http://unused.test:1"
        connections
        (ioError (userError "the stage's token reader was not replaced"))
        (const (ioError (userError "the stage's renewer was not replaced")))
        (RetryOptions (Time.now time) (Time.waitUntil time) (pure 0))
        timing
        (UUID.fromWords 0 0 0 <$> atomically (modifyTVar' ids (+ 1) >> readTVar ids))
        (Set.fromList Channels.globalChannels)
        (pure Map.empty)
        (\_ _ -> pure ())
    )

-- | A knowledge base at the stage's gateway, whose did the gateway's description of it makes.
registered :: Text -> KnowledgeBase
registered key =
  KnowledgeBase {knowledgeBaseDid = (either error userIdValue (Identity.kbDid (domainOf key))), knowledgeBaseEndpoint = (KbEndpointHttpEndpoint (HttpEndpoint {httpEndpointHost = "gateway.test", httpEndpointKind = HttpEndpointKindHttp, httpEndpointPort = 80, httpEndpointProtocol = HttpEndpointProtocolHttp})), knowledgeBaseId = key, knowledgeBaseLabel = key, knowledgeBaseLastRead = Nothing}

domainOf :: Text -> Text
domainOf key = key <> ".example.test"

-- | A sign-in of the stage's issuer, naming the person whose key is given, or nobody.
signInOf :: Text -> Text -> Text -> Maybe Text -> StoredSession
signInOf clientId access refresh person =
  StoredSession {storedSessionAccess = AccessToken access, storedSessionClientId = clientId, storedSessionPersonKey = person, storedSessionRefresh = refresh, storedSessionRevocationEndpoint = (Just "http://issuer.test/revoke"), storedSessionTokenEndpoint = "http://issuer.test/token"}

answer :: Stage -> Bytes.ByteString -> (Bytes.ByteString -> STM ()) -> STM () -> IO ()
answer stage request write hangUp = dispatch (decodeUtf8 (Char8.takeWhile (/= '?') (route request)))
  where
    dispatch path
      | path == routePath GetCurrentUser = do
          refused <- atomically $ do
            modifyTVar' (stageAskedWho stage) (<> [token])
            Set.member token <$> readTVar (stageRefusesWho stage)
          atomically $
            if refused
              then write (jsonReply 401 (toJSON (ErrorResponse {errorResponseCode = Nothing, errorResponseDetails = Nothing, errorResponseError = "Invalid token", errorResponseHint = Nothing})))
              else do
                readTVar (stageWhoHeld stage) >>= check . not
                readTVar (stageWho stage) >>= maybe hangUp (write . jsonReply 200)
      | path == "/token" =
          atomically $
            readTVar (stageGrants stage) >>= \granting -> case granting of
              [] -> write (jsonReply 400 (object ["error" .= String "invalid_grant"]))
              (access, refresh) : rest -> do
                writeTVar (stageGrants stage) rest
                write
                  ( jsonReply
                      200
                      ( object
                          [ "access_token" .= access,
                            "refresh_token" .= refresh,
                            "token_type" .= String "Bearer",
                            "expires_in" .= (3600 :: Int)
                          ]
                      )
                  )
      | path == "/revoke" = atomically (write (jsonReply 200 (object [])))
      | path == routePath SubscribeToBus,
        Right subscription <- decoded = atomically $ do
          modifyTVar' (stageSubscriptions stage) (<> [subscription])
          modifyTVar' (stageStreams stage) (<> [write])
          write "HTTP/1.1 200 OK\r\nContent-Type: text/event-stream\r\nConnection: close\r\n\r\n"
          retained <- readTVar (stageReplies stage)
          forM_ (fromMaybe [] (busSubscribeRequestPendingReplies subscription)) $ \correlation -> mapM_ write (Map.lookup correlation retained)
      | path == routePath EmitOnBus,
        Right emitted <- decoded = atomically $ do
          forM_ (replyTo emitted) $ \(correlation, frame) -> do
            let event = sse Nothing (toJSON frame)
            modifyTVar' (stageReplies stage) (Map.insert correlation event)
            readTVar (stageStreams stage) >>= mapM_ ($ event)
          write (jsonReply 202 (toJSON (BusEmitAccepted (Just 1))))
      | otherwise = atomically $ do
          modifyTVar' (stageStrays stage) (<> [request])
          write (jsonReply 404 (toJSON (ErrorResponse {errorResponseCode = Nothing, errorResponseDetails = Nothing, errorResponseError = "the stage has no answer for this", errorResponseHint = Nothing})))
    decoded :: (FromJSON value) => Either String value
    decoded = eitherDecodeStrict' (bodyOf request)
    token =
      maybe "" decodeUtf8 $
        listToMaybe
          [ bearer
          | line <- Char8.lines (fst (Bytes.breakSubstring "\r\n\r\n" request)),
            let (name, rest) = Char8.break (== ':') line,
            Char8.map toLower name == "authorization",
            Just bearer <- [Bytes.stripPrefix "Bearer " (Char8.strip (Bytes.drop 1 rest))]
          ]
    replyTo emitted = do
      correlation <- busEmitRequestCorrelationId emitted
      let asked = busEmitRequestChannel emitted
          payload = Object (busEmitRequestPayloadAdditionalProperties (busEmitRequestPayload emitted))
      if asked == channelName BrowseKbRequested
        then Just (correlation, frameOf BrowseKbResult correlation (Types.BrowseKbResult (KbDescription {kbDescriptionDomain = (domainOf "kb-a"), kbDescriptionGitBranch = Nothing, kbDescriptionName = "KB A"})))
        else
          if asked == channelName BrowseResourceRequested
            then do
              resource <- either (const Nothing) (Just . browseResourceRequestResourceId) (decodePayload BrowseResourceRequested payload)
              Just (correlation, frameOf BrowseResourceResult correlation (Types.BrowseResourceResult (BrowseResourceResultResponse {browseResourceResultResponseLastSequence = 1, browseResourceResultResponseResource = (freshResource resource)})))
            else Nothing

-- | The resource the stage describes as it is now: named fresh, and of no representation.
freshResource :: ResourceId -> ResourceDescriptor
freshResource resource = case fromJSON (object ["@context" .= String "https://schema.org", "@id" .= resource, "name" .= String "fresh", "representations" .= ([] :: [Value])]) of
  Success described -> described
  Error problem -> error ("the stage's fresh resource is no ResourceDescriptor: " ++ problem)

frameOf :: Channel scope payload -> Text -> payload -> BusFrame
frameOf channel correlation payload = case encodePayload channel payload of
  Object fields -> BusFrame (channelName channel) (Just correlation) (BusFramePayload fields) Nothing
  _ -> error "a reply's payload is no object"

sse :: Maybe Text -> Value -> Bytes.ByteString
sse identity frame =
  "event: bus-event\n"
    <> maybe "" (\value -> "id: " <> encodeUtf8 value <> "\n") identity
    <> "data: "
    <> Lazy.toStrict (encode frame)
    <> "\n\n"

-- | Gives every stream a frame, with the event id when there is one.
send :: Stage -> Maybe Text -> Value -> STM ()
send stage identity frame = readTVar (stageStreams stage) >>= mapM_ ($ sse identity frame)

-- | Each scope a stream named, and the place it resumed it from.
scopedOf :: BusSubscribeRequest -> [(Text, Maybe Text)]
scopedOf subscription = [(resourceIdValue (busSubscribeRequestScopedItemScope item), busSubscribeRequestScopedItemLastEventId item) | item <- fromMaybe [] (busSubscribeRequestScoped subscription)]

-- | The place the first stream that named scope resumed it from, Nothing for none; Nothing while no stream has named
-- it.
resumedFrom :: Stage -> Text -> STM (Maybe (Maybe Text))
resumedFrom stage scope = listToMaybe . mapMaybe (lookup scope . scopedOf) <$> readTVar (stageSubscriptions stage)

-- | The place the first stream that named with resumed scope from, Nothing for none; Nothing while no stream has
-- named with, or the first that did named no scope.
resumedWith :: Stage -> Text -> Text -> STM (Maybe (Maybe Text))
resumedWith stage scope with = do
  subscribed <- map scopedOf <$> readTVar (stageSubscriptions stage)
  pure
    ( case [scoped | scoped <- subscribed, any ((== with) . fst) scoped] of
        scoped : _ -> lookup scope scoped
        [] -> Nothing
    )
