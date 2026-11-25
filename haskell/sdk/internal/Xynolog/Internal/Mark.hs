module Xynolog.Internal.Mark (MarkNamespace, newMark, annotation, delete, archive, unarchive, updateEntityTypes, delegate, request, submit, reportDeleteError) where

import Control.Concurrent.STM (STM)
import Data.Text (Text)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels hiding (MarkCreateRequest)
import Xynolog.Internal.DelegatedVerbs qualified as Verb
import Xynolog.Internal.Delegation qualified as Delegation
import Xynolog.Internal.Local qualified as Local
import Xynolog.Internal.Running qualified as Running
import Xynolog.Internal.Transport qualified as LocalBus
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types

data MarkNamespace = MarkNamespace Bus.Bus LocalBus.EventBus Timing.Settings Delegation.Follower

newMark :: Bus.Bus -> LocalBus.EventBus -> Timing.Settings -> Delegation.Follower -> MarkNamespace
newMark = MarkNamespace

annotation :: MarkNamespace -> CreateAnnotationRequest -> IO AnnotationId
annotation (MarkNamespace wire _ timing _) input =
  markCreateOkResponseAnnotationId . markCreateOkResponse
    <$> Bus.request wire MarkCreateRequestOperation (MarkCreateRequest {markCreateRequestRequest = input, markCreateRequestResourceId = (annotationTargetSource (createAnnotationRequestTarget input))}) (Timing.busRequestTimeoutMs timing)

delete :: MarkNamespace -> ResourceId -> AnnotationId -> IO MarkDeleteOkResponse
delete (MarkNamespace wire _ timing _) resource mark =
  markDeleteOkResponse
    <$> Bus.request wire MarkDeleteOperation (MarkDeleteCommand Nothing mark (Just resource)) (Timing.busRequestTimeoutMs timing)

archive :: MarkNamespace -> ResourceId -> IO EmptyBusPayload
archive (MarkNamespace wire _ timing _) resource =
  Bus.request wire MarkArchiveOperation (MarkArchiveCommand {markArchiveCommandUserId = Nothing, markArchiveCommandKeepFile = Nothing, markArchiveCommandResourceId = resource, markArchiveCommandStorageUri = Nothing}) (Timing.busRequestTimeoutMs timing)

unarchive :: MarkNamespace -> ResourceId -> IO EmptyBusPayload
unarchive (MarkNamespace wire _ timing _) resource =
  Bus.request wire MarkUnarchiveOperation (MarkUnarchiveCommand Nothing resource Nothing) (Timing.busRequestTimeoutMs timing)

updateEntityTypes :: MarkNamespace -> ResourceId -> [Text] -> [Text] -> IO EmptyBusPayload
updateEntityTypes (MarkNamespace wire _ timing _) resource current updated =
  Bus.request wire MarkUpdateEntityTypesOperation (MarkUpdateEntityTypesCommand {markUpdateEntityTypesCommandUserId = Nothing, markUpdateEntityTypesCommandCurrentEntityTypes = current, markUpdateEntityTypesCommandResourceId = resource, markUpdateEntityTypesCommandUpdatedEntityTypes = updated}) (Timing.busRequestTimeoutMs timing)

delegate :: MarkNamespace -> ResourceId -> MarkJobParams -> IO (Running.Running (Delegation.JobEvent MarkJobCompleteCommand) MarkJobCompleteCommand)
delegate (MarkNamespace _ _ _ follower) resource params =
  Delegation.follow
    follower
    (JobCreateCommandMarkJobCreateCommand (MarkJobCreateCommand {markJobCreateCommandRoles = Nothing, markJobCreateCommandUserId = Nothing, markJobCreateCommandJobType = MarkJobCreateCommandJobTypeMark, markJobCreateCommandParams = params, markJobCreateCommandResourceId = resource}))
    Verb.mark
    resource
    Nothing

request :: MarkNamespace -> ResourceId -> AnnotationSelector -> Motivation -> STM ()
request (MarkNamespace _ local _ _) resource selector motivation = Local.signal local MarkRequested (MarkRequestedEvent {markRequestedEventMotivation = motivation, markRequestedEventSelector = selector, markRequestedEventSource = resource}) NoScope

submit :: MarkNamespace -> MarkSubmitEvent -> STM ()
submit (MarkNamespace _ local _ _) input = Local.signal local MarkSubmit input NoScope

reportDeleteError :: MarkNamespace -> ResourceErrorEvent -> STM ()
reportDeleteError (MarkNamespace _ local _ _) input = Local.signal local MarkDeleteError input NoScope
