module Xynolog.Internal.Gather (GatherNamespace, newGather, annotation, resource, referencedBy, controls, dispose) where

import Data.Maybe (fromMaybe)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels
import Xynolog.Internal.Cache qualified as Cache
import Xynolog.Internal.Generated.CacheRefresh qualified as Fact
import Xynolog.Internal.Queries (cacheOptions, oneReport)
import Xynolog.Internal.Refresh qualified as Refresh
import Xynolog.Internal.Running qualified as Running
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Transport qualified as Transport
import Xynolog.Types

data GatherNamespace = GatherNamespace Bus.Bus Timing.Settings (Cache.Cache ResourceId Fact.ReferencedByValue)

newGather :: Bus.Bus -> Transport.Transport -> Bus.BusOptions -> Timing.Settings -> IO GatherNamespace
newGather wire carrier clock timing =
  GatherNamespace wire timing
    <$> Cache.newCache
      ( \identity ->
          getReferencedByResponseReferencedBy . gatherReferencedByResultResponse
            <$> Bus.request wire GatherReferencedByRequestedOperation (GatherReferencedByRequest Nothing identity) (Timing.busRequestTimeoutMs timing)
      )
      (cacheOptions clock timing (Transport.subscribeToResource carrier))

annotation :: GatherNamespace -> ResourceId -> AnnotationId -> Maybe GatherAnnotationOptions -> IO (Running.Running GatherAnnotationComplete GatherAnnotationComplete)
annotation (GatherNamespace wire timing _) identity mark options =
  oneReport $
    Bus.request wire GatherRequestedOperation (GatherAnnotationRequest mark (Just withWindow) identity) (Timing.busRequestTimeoutMs timing)
  where
    chosen = fromMaybe (GatherAnnotationOptions Nothing Nothing Nothing) options
    withWindow = chosen {gatherAnnotationOptionsContextWindow = Just (fromMaybe 2000 (gatherAnnotationOptionsContextWindow chosen))}

resource :: GatherNamespace -> ResourceId -> Maybe GatherResourceOptions -> IO GatheredContext
resource (GatherNamespace wire timing _) identity options =
  gatherResourceCompleteResponse
    <$> Bus.request wire GatherResourceRequestedOperation (GatherResourceRequest selected identity) (Timing.busRequestTimeoutMs timing)
  where
    chosen = fromMaybe (GatherResourceOptions Nothing Nothing Nothing Nothing Nothing) options
    selected =
      GatherResourceRequestOptions
        (fromMaybe 2 (gatherResourceOptionsDepth chosen))
        (case gatherResourceOptionsExcludeEntityTypes chosen of Just [] -> Nothing; other -> other)
        (fromMaybe True (gatherResourceOptionsIncludeContent chosen))
        (fromMaybe False (gatherResourceOptionsIncludeSummary chosen))
        (fromMaybe 10 (gatherResourceOptionsMaxResources chosen))

referencedBy :: GatherNamespace -> ResourceId -> Cache.Query [GetReferencedByResponseReferencedByItem]
referencedBy (GatherNamespace _ _ cache) = Cache.query cache

controls :: GatherNamespace -> [(Fact.Query, Refresh.Acts)]
controls (GatherNamespace _ _ cache) =
  [ ( Fact.ReferencedBy,
      Refresh.Acts
        (Refresh.cacheTargets cache (\info identity -> Refresh.subjectResource info == Just identity))
        Nothing
        Nothing
    )
  ]

dispose :: GatherNamespace -> IO ()
dispose (GatherNamespace _ _ cache) = Cache.dispose cache
