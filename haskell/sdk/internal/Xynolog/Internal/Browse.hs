{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Xynolog.Internal.Browse
  ( BrowseNamespace,
    newBrowse,
    controls,
    persistencePending,
    fetching,
    keepIn,
    dispose,
    resource,
    resources,
    annotations,
    annotation,
    entityTypes,
    tagSchemas,
    engines,
    events,
    resourceContent,
    resourceGraph,
    resourceAnchoredText,
    resourceRepresentation,
    resourceRepresentationStream,
    resourceEvents,
    annotationHistory,
    files,
    kb,
    click,
    openResource,
    resourceViewed,
  )
where

import Control.Concurrent.Async (mapConcurrently_)
import Control.Concurrent.STM
import Control.Exception (SomeAsyncException, SomeException, catch, fromException, throwIO)
import Control.Monad (void)
import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.ByteString (ByteString)
import Data.List (find)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Streaming (Of, Stream)
import Xynolog.Annotations qualified as Annotations
import Xynolog.Bus qualified as Bus
import Xynolog.Channels
import Xynolog.Content qualified as Content
import Xynolog.ErrorCodes qualified as Code
import Xynolog.Errors (TransportError (..))
import Xynolog.Internal.Cache qualified as Cache
import Xynolog.Internal.CacheDocument (Whole (..))
import Xynolog.Internal.Coupled qualified as Coupled
import Xynolog.Internal.Generated.CachePersistence qualified as Persisted
import Xynolog.Internal.Generated.CacheRefresh qualified as Fact
import Xynolog.Internal.Lifetime qualified as Lifetime
import Xynolog.Internal.Local qualified as Local
import Xynolog.Internal.Persistence qualified as Persistence
import Xynolog.Internal.Queries (cacheOptions)
import Xynolog.Internal.Refresh qualified as Refresh
import Xynolog.Internal.Transport qualified as LocalBus
import Xynolog.Resources qualified as Resources
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Transport qualified as Transport
import Xynolog.Types

data AnnotationKey = AnnotationKey ResourceId AnnotationId

instance ToJSON AnnotationKey where toJSON (AnnotationKey _ identity) = toJSON identity

data BrowseNamespace = BrowseNamespace
  { signalLifetime :: Lifetime.Lifetime,
    carrier :: Transport.Transport,
    wire :: Bus.Bus,
    local :: LocalBus.EventBus,
    content :: Content.ContentTransport,
    timing :: Timing.Settings,
    resourceCache :: Cache.Cache ResourceId Fact.ResourceValue,
    resourcesCache :: Cache.Cache BrowseResourcesRequest Fact.ResourcesValue,
    annotationsCache :: Cache.Cache ResourceId Fact.AnnotationsValue,
    annotationCache :: Cache.Cache AnnotationKey Fact.AnnotationValue,
    entityTypesCache :: Cache.Cache Whole Fact.EntityTypesValue,
    tagSchemasCache :: Cache.Cache Whole Fact.TagSchemasValue,
    enginesCache :: Cache.Cache () Fact.EnginesValue,
    limitsCache :: Cache.Cache Text [EngineLimits],
    eventsCache :: Cache.Cache ResourceId Fact.EventsValue
  }

newBrowse :: Bus.Bus -> LocalBus.EventBus -> Transport.Transport -> Content.ContentTransport -> Bus.BusOptions -> Timing.Settings -> IO BrowseNamespace
newBrowse bus signals carrier contents clock settings = do
  let ask operation input = Bus.request bus operation input (Timing.busRequestTimeoutMs settings)
      unscoped = cacheOptions clock settings (const (pure (pure ())))
      scoped = cacheOptions clock settings (Transport.subscribeToResource carrier)
  descriptors <-
    Cache.newCache
      (\identity -> browseResourceResultResponseResource . browseResourceResultResponse <$> ask BrowseResourceRequestedOperation (BrowseResourceRequest identity))
      scoped
  pages <- Cache.newCache (fmap browseResourcesResultResponse . ask BrowseResourcesRequestedOperation) unscoped
  lists <- Cache.newCache (Content.getAnnotations contents Nothing) scoped
  details <-
    Cache.newCache
      (\(AnnotationKey identity mark) -> getAnnotationResponseAnnotation . browseAnnotationResultResponse <$> ask BrowseAnnotationRequestedOperation (BrowseAnnotationRequest {browseAnnotationRequestAnnotationId = mark, browseAnnotationRequestResourceId = identity}))
      (cacheOptions clock settings (\(AnnotationKey identity _) -> Transport.subscribeToResource carrier identity))
  vocabulary <- Cache.newCache (\_ -> getEntityTypesResponseEntityTypes . browseEntityTypesResultResponse <$> ask BrowseEntityTypesRequestedOperation (BrowseEntityTypesRequest mempty)) unscoped
  schemas <- Cache.newCache (\_ -> getTagSchemasResponseTagSchemas . browseTagSchemasResultResponse <$> ask BrowseTagSchemasRequestedOperation (BrowseTagSchemasRequest mempty)) unscoped
  models <- Cache.newCache (\() -> browseEnginesResultResponseEngines . browseEnginesResultResponse <$> ask BrowseEnginesRequestedOperation (BrowseEnginesRequest mempty)) unscoped
  limits <-
    Cache.newCache
      ( \name -> do
          case find (\operation -> let (request, _, _) = operationChannels operation in channelName request == name) limitsOperations of
            Nothing -> ioError (userError "unknown derived inference-limits operation")
            Just operation ->
              (inferenceLimitsResultResponseLimits . inferenceLimitsResultResponse <$> ask operation (InferenceLimitsRequest mempty))
                `catch` ( \(problem :: SomeException) -> case fromException problem :: Maybe SomeAsyncException of
                            Just _ -> throwIO problem
                            Nothing -> pure []
                        )
      )
      unscoped
  history <-
    Cache.newCache
      (\identity -> getEventsResponseEvents . browseEventsResultResponse <$> ask BrowseEventsRequestedOperation (BrowseEventsRequest {browseEventsRequestLimit = Nothing, browseEventsRequestResourceId = identity, browseEventsRequestType = Nothing, browseEventsRequestUserId = Nothing}))
      scoped
  life <- Lifetime.newLifetime "browse is disposed"
  pure (BrowseNamespace life carrier bus signals contents settings descriptors pages lists details vocabulary schemas models limits history)

resource :: BrowseNamespace -> ResourceId -> Cache.Query ResourceDescriptor
resource namespace = Cache.query (resourceCache namespace)

resources :: BrowseNamespace -> Maybe BrowseResourcesRequest -> Cache.Query ListResourcesResponse
resources namespace options = Cache.query (resourcesCache namespace) chosen
  where
    chosen = fromMaybe (BrowseResourcesRequest {browseResourcesRequestArchived = Nothing, browseResourcesRequestEntityType = Nothing, browseResourcesRequestLimit = Nothing, browseResourcesRequestOffset = Nothing}) options

annotations :: BrowseNamespace -> ResourceId -> Cache.Query [Annotation]
annotations namespace identity = getAnnotationsResponseAnnotations <$> Cache.query (annotationsCache namespace) identity

annotation :: BrowseNamespace -> ResourceId -> AnnotationId -> Cache.Query Annotation
annotation namespace identity mark = Cache.query (annotationCache namespace) (AnnotationKey identity mark)

entityTypes :: BrowseNamespace -> Cache.Query [Text]
entityTypes namespace = Cache.query (entityTypesCache namespace) Whole

tagSchemas :: BrowseNamespace -> Cache.Query [TagSchema]
tagSchemas namespace = Cache.query (tagSchemasCache namespace) Whole

engines :: BrowseNamespace -> Cache.Query [EngineWithLimits]
engines namespace = case reports of
  [] -> error "the derived inference-limits operation set is empty"
  first : rest ->
    Cache.liftQuery2
      combine
      joinLimits
      (Cache.query (enginesCache namespace) ())
      (foldl (Cache.liftQuery2 combineReports (++)) first rest)
  where
    reports = [Cache.query (limitsCache namespace) (channelName request) | operation <- limitsOperations, let (request, _, _) = operationChannels operation]
    combine state limits = case state of
      Cache.Pending -> Cache.Pending
      Cache.Failed problem -> Cache.Failed problem
      Cache.Ready entries -> Cache.Ready (joinLimits entries (fromMaybe [] (Cache.readyValue limits)))
    combineReports left right = Cache.Ready (fromMaybe [] (Cache.readyValue left) ++ fromMaybe [] (Cache.readyValue right))
    joinLimits entries limits =
      [ EngineWithLimits
          (engineEntryEngine entry)
          (engineEntryJobs entry)
          (engineLimitsLimits <$> find (\report -> engineLimitsEngine report == engineEntryEngine entry) limits)
      | entry <- entries
      ]

events :: BrowseNamespace -> ResourceId -> Cache.Query [AttributedEvent]
events namespace = Cache.query (eventsCache namespace)

resourceContent :: BrowseNamespace -> ResourceId -> IO Text
resourceContent namespace identity = do
  binary <- Content.getBinary (content namespace) Nothing identity
  Resources.decodeRepresentation (Content.contentBytes binary) (Content.contentType binary)

resourceGraph :: BrowseNamespace -> ResourceId -> IO GetResourceResponse
resourceGraph namespace identity = Content.getResourceGraph (content namespace) Nothing identity

resourceAnchoredText :: BrowseNamespace -> ResourceId -> IO AnchoredTextAnswer
resourceAnchoredText namespace identity = Content.getAnchoredText (content namespace) Nothing identity

resourceRepresentation :: BrowseNamespace -> ResourceId -> IO Content.BinaryContent
resourceRepresentation namespace identity = Content.getBinary (content namespace) Nothing identity

resourceRepresentationStream :: BrowseNamespace -> ResourceId -> (Text -> Stream (Of ByteString) IO () -> IO result) -> IO result
resourceRepresentationStream namespace identity consume = Content.getBinaryStream (content namespace) Nothing identity consume

resourceEvents :: BrowseNamespace -> ResourceId -> IO [AttributedEvent]
resourceEvents namespace identity =
  getEventsResponseEvents . browseEventsResultResponse
    <$> Bus.request (wire namespace) BrowseEventsRequestedOperation (BrowseEventsRequest {browseEventsRequestLimit = Nothing, browseEventsRequestResourceId = identity, browseEventsRequestType = Nothing, browseEventsRequestUserId = Nothing}) (Timing.busRequestTimeoutMs (timing namespace))

annotationHistory :: BrowseNamespace -> ResourceId -> AnnotationId -> IO GetAnnotationHistoryResponse
annotationHistory namespace identity mark =
  browseAnnotationHistoryResultResponse
    <$> Bus.request (wire namespace) BrowseAnnotationHistoryRequestedOperation (BrowseAnnotationHistoryRequest {browseAnnotationHistoryRequestAnnotationId = mark, browseAnnotationHistoryRequestResourceId = identity}) (Timing.busRequestTimeoutMs (timing namespace))

files :: BrowseNamespace -> Maybe Text -> Maybe BrowseDirectoryRequestSort -> IO BrowseDirectoryResultResponse
files namespace path sort =
  browseDirectoryResultResponse
    <$> Bus.request
      (wire namespace)
      BrowseDirectoryRequestedOperation
      (BrowseDirectoryRequest (fromMaybe "." path) (Just (fromMaybe BrowseDirectoryRequestSortName sort)))
      (Timing.busRequestTimeoutMs (timing namespace))

kb :: BrowseNamespace -> IO KbDescription
kb namespace = browseKbResultResponse <$> Bus.request (wire namespace) BrowseKbRequestedOperation (BrowseKbRequest mempty) (Timing.busRequestTimeoutMs (timing namespace))

-- | Open an annotation for this viewer, and where it is on this viewer's
-- screen when that is known.
click :: BrowseNamespace -> AnnotationId -> Maybe AnchorRect -> STM ()
click namespace identity anchorRect = Local.signal (local namespace) BrowseClick (BrowseClickEvent {browseClickEventAnchorRect = anchorRect, browseClickEventAnnotationId = identity}) NoScope

openResource :: BrowseNamespace -> ResourceId -> STM ()
openResource namespace identity = Local.signal (local namespace) BrowseResourceOpen (BrowseResourceOpenEvent identity) NoScope

resourceViewed :: BrowseNamespace -> ResourceId -> IO ()
resourceViewed namespace identity =
  void
    $ Lifetime.start (signalLifetime namespace)
    $ void (Bus.emit (wire namespace) BrowseResourceViewed (BrowseResourceViewedEvent identity) NoScope Nothing)
      `catch` ( \(problem :: SomeException) -> case fromException problem :: Maybe SomeAsyncException of
                  Just _ -> throwIO problem
                  Nothing ->
                    LocalBus.reportFailure
                      (carrier namespace)
                      ( fromMaybe
                          (TransportError Code.TransportError "resource-viewed report failed" Nothing Nothing)
                          (fromException problem)
                      )
              )

-- | The persisted queries keep their values in @persistence@ from now on,
-- each beginning with what it kept, and every save writes the places noted.
keepIn :: BrowseNamespace -> Persistence.CachePersistence -> Coupled.Coupled -> IO ()
keepIn namespace persistence coupled = do
  let kept query decodeKey cache = Persistence.persister persistence coupled (timing namespace) query decodeKey >>= Cache.attach cache
  kept Persisted.Resource (\key _ -> parseJSON key) (resourceCache namespace)
  kept Persisted.Annotations (\key _ -> parseJSON key) (annotationsCache namespace)
  kept Persisted.Annotation (\key value -> AnnotationKey (Annotations.targetSource (annotationTarget value)) <$> parseJSON key) (annotationCache namespace)
  kept Persisted.EntityTypes (\key _ -> parseJSON key) (entityTypesCache namespace)
  kept Persisted.TagSchemas (\key _ -> parseJSON key) (tagSchemasCache namespace)

persistencePending :: BrowseNamespace -> STM Bool
persistencePending = anyKept Cache.persistencePending

fetching :: BrowseNamespace -> STM Bool
fetching = anyKept Cache.fetching

anyKept :: (forall key value. Cache.Cache key value -> STM Bool) -> BrowseNamespace -> STM Bool
anyKept probe namespace =
  or
    <$> sequence
      [ probe (resourceCache namespace),
        probe (annotationsCache namespace),
        probe (annotationCache namespace),
        probe (entityTypesCache namespace),
        probe (tagSchemasCache namespace)
      ]

controls :: BrowseNamespace -> [(Fact.Query, Refresh.Acts)]
controls namespace =
  [ (Fact.Resource, refetch (resourceCache namespace) ofResource),
    ( Fact.Annotations,
      (refetch (annotationsCache namespace) ofResource)
        { Refresh.write = Just (Refresh.patchTargets (annotationsCache namespace) ofResource patchList)
        }
    ),
    ( Fact.Annotation,
      (refetch (annotationCache namespace) ofAnnotation)
        { Refresh.write = Just (Refresh.writeTargets (annotationCache namespace) ofAnnotation (\info prior -> case Refresh.subjectWritten info of Just value -> Just value; Nothing -> prior)),
          Refresh.end = Just (Refresh.endTargets (annotationCache namespace) ofAnnotation)
        }
    ),
    (Fact.Events, refetch (eventsCache namespace) ofResource),
    (Fact.Resources, refetch (resourcesCache namespace) (\_ _ -> True)),
    (Fact.EntityTypes, refetch (entityTypesCache namespace) (\_ _ -> True)),
    (Fact.TagSchemas, refetch (tagSchemasCache namespace) (\_ _ -> True)),
    ( Fact.Engines,
      Refresh.Acts
        ( \info reach -> do
            entries <- Refresh.cacheTargets (enginesCache namespace) (\_ _ -> True) info reach
            limits <- Refresh.cacheTargets (limitsCache namespace) (\_ _ -> True) info reach
            pure (entries ++ limits)
        )
        Nothing
        Nothing
    )
  ]
  where
    refetch cache matches = Refresh.Acts (Refresh.cacheTargets cache matches) Nothing Nothing
    ofResource info identity = Refresh.subjectResource info == Just identity
    ofAnnotation info (AnnotationKey identity mark) = case Refresh.subjectAnnotation info of
      Just selected -> mark == selected
      Nothing -> Refresh.subjectResource info == Just identity
    patchList info prior = case Refresh.subjectWritten info of
      Nothing -> prior
      Just written ->
        let entries = getAnnotationsResponseAnnotations prior
            found = any ((== annotationId written) . annotationId) entries
            updated = if found then map (\held -> if annotationId held == annotationId written then written else held) entries else entries ++ [written]
         in prior {getAnnotationsResponseAnnotations = updated}

dispose :: BrowseNamespace -> IO ()
dispose namespace =
  mapConcurrently_
    id
    [ Lifetime.close (signalLifetime namespace),
      Cache.dispose (resourceCache namespace),
      Cache.dispose (resourcesCache namespace),
      Cache.dispose (annotationsCache namespace),
      Cache.dispose (annotationCache namespace),
      Cache.dispose (entityTypesCache namespace),
      Cache.dispose (tagSchemasCache namespace),
      Cache.dispose (enginesCache namespace),
      Cache.dispose (limitsCache namespace),
      Cache.dispose (eventsCache namespace)
    ]
