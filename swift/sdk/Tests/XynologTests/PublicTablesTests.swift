import Foundation
import Synchronization
import Testing
import Xynolog

// What Protocol states, reached as an application reaches it: through the public API alone. This
// file imports Xynolog without @testable, so a table that is not public fails to compile here.

@Test func anOperationNamesItsChannelsAndTheMembersItsRepliesCarry() {
  let browse = Operations.browseKbRequested
  #expect(browse.request.name == Channels.browseKbRequested.name)
  #expect(bridgedChannels.contains(browse.result.name))
  #expect(bridgedChannels.contains(browse.failure.name))
  #expect(browse.replyNames.allSatisfy { !$0.isEmpty })
  #expect(Channels.browseKbRequested.stamps.allSatisfy { $0.hasPrefix("_") })
}

@Test func everyPersistedEventIsAChannelAndEveryScopedChannelIsDeliveredByScope() {
  #expect(!persistedEventTypes.isEmpty)
  #expect(!resourceScopedChannels.isEmpty)
  #expect(resourceScopedChannels.allSatisfy { !bridgedChannels.contains($0) })
}

@Test func theTimingsAreProtocolsOwn() {
  #expect(Timings.reconnectMs > 0)
  #expect(Timings.emitRetry.attempts > 0)
  #expect(Timings.emitRetry.initialDelayMs <= Timings.emitRetry.maxDelayMs)
}

@Test func theGatewaysRoutesAreItsMethodsAndPaths() {
  #expect(GatewayRoute.getHealth.method == "GET")
  #expect(GatewayRoute.getResourceRepresentation.path.contains("{id}"))
  #expect(GatewayMedia.subscribeToBusAnswers == "text/event-stream")
  #expect(!GatewayHeader.idempotencyKey.isEmpty)
  #expect(UploadField.allCases.contains(.file))
  #expect(clientSecretForm(clientId: "a", clientSecret: "b").contains { $0.1 == "a" })
}

@Test func theControlApiNamesEachMethodAndNotificationByWhatItCarries() {
  let about: ControlMethod<AboutParams, AboutResult> = Control.launcherAbout
  #expect(about.name.hasPrefix("launcher."))
  #expect(!about.exclusive)
  #expect(Control.serviceRun.sends.contains(Control.notificationsServiceStarted.name))
  let cancelled: ControlNotification<Cancelled> = Control.notificationsCancelled
  #expect(cancelled.from == .client)
  #expect(Control.notificationsProgress.from == .launcher)
  #expect(!ControlErrorCode.allCases.isEmpty)
}

@Test func theSpecsTablesAndFieldsArePublic() {
  #expect(!telemetrySpans.isEmpty)
  #expect(!telemetryMetrics.isEmpty)
  #expect(!oauthClients.isEmpty)
  #expect(!mediaTypes.isEmpty)
  #expect(!encodings.isEmpty)
  #expect(!cacheQueries.isEmpty)
  #expect(!credentialNames.isEmpty)
  #expect(!extensionAliases.isEmpty)
  #expect(locales.allSatisfy { !$0.code.isEmpty && !$0.englishName.isEmpty })
  #expect(traceField.hasPrefix("_"))
  #expect(userField.hasPrefix("_"))
  #expect(!signInLockName.isEmpty)
  #expect(!attributeBusChannel.isEmpty)
  _ = (signInScope, ownerOnlyDirectory, ownerOnlyFile)
}

/// A transport that delivers what a test feeds it and keeps each emit's channel and correlation id.
private final class Answering: Transport {
  let baseUrl = "http://kb.test"
  let state = Watched<ConnectionState>(.open)
  private let events: Events<Carried>
  private let kept = Mutex<[[String?]]>([])
  init(_ events: Events<Carried>) { self.events = events }
  var emitted: [[String?]] { kept.withLock { $0 } }
  func frames(_ channels: [String]) async throws -> Events<Carried> { events }
  func subscribeToResource(_ resource: ResourceId) async -> ResourceHold { ResourceHold {} }
  func emit(
    channel: String, payload: [String: JSONValue], scope: ResourceId?, correlationId: String?
  ) async throws -> Int? {
    kept.withLock { $0.append([channel, correlationId]) }
    return 1
  }
  func request(operation: String, payload: [String: JSONValue]) async throws -> [String: JSONValue]
  {
    throw BusRequestError(.busRejected, "\(operation) is not asked here")
  }
  func tellFailures(to listener: @escaping @Sendable (TransportError) -> Void) {}
  func dispose() { events.dispose() }
}

@Test func aServiceAnswersAnOperationsRequestOnItsReplyChannelUnderItsCorrelationId() async throws {
  let operation = Operations.browseKbRequested
  let (stream, feed) = AsyncThrowingStream<Carried, any Error>.makeStream()
  let transport = Answering(Events(stream, stop: { feed.finish() }))
  let bus = Bus(transport)
  var requests = try await bus.frames(operation.request).makeAsyncIterator()
  feed.yield(
    .frame(ReceivedFrame(channel: operation.request.name, correlationId: "c-1", payload: [:])))
  guard case .delivered(let request) = try await requests.next() else {
    Issue.record("The request was not delivered")
    return
  }
  _ = try await bus.emit(
    operation.failure, CommandError(message: "Not served here"),
    correlationId: request.frame.correlationId)
  #expect(transport.emitted == [[operation.failure.name, "c-1"]])
}

@Test func aValueIsHeldToASchemaByName() {
  let fault = faultOf("CommandError", .object([:]))
  #expect(fault?.member == "message")
  #expect(fault?.reason == .lacks)
  #expect(faultOf("CommandError", .object(["message": .string("No")])) == nil)
}

@Test func everyServiceTableIsProtocolsAsItsSchemasModelReadsIt() throws {
  #expect(!serviceTables.isEmpty)
  for (file, table) in serviceTables {
    let written = try JSONDecoder().decode(JSONValue.self, from: JSONEncoder().encode(table))
    #expect(try written == Spec.read(file), "\(file)")
  }
}

@Test func theRetryRulesAreProtocolsAsTheirSchemasModelReadsThem() throws {
  let written = try JSONDecoder().decode(JSONValue.self, from: JSONEncoder().encode(retryRules))
  #expect(try written == Spec.read("retry/rules.json"))
  #expect(RetryContext.job.retryable(status: retryRules.job.statusFrom, method: nil, keyed: false))
}

@Test func everyRetryRuleProtocolStatesIsAContext() throws {
  let rules = try Spec.read("retry/rules.json").object.keys.filter { !$0.hasPrefix("$") }
  #expect(Set(RetryContext.allCases.map(\.rawValue)) == Set(rules))
}
