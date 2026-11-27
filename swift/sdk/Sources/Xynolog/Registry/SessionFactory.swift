import AsyncHTTPClient

public struct SessionFactoryOptions: Sendable {
  public let kb: KnowledgeBase
  public let storage: any SessionStorage
  public let signals: SessionSignals
}

public protocol SessionFactory: Sendable {
  func session(_ options: SessionFactoryOptions) async throws -> OpenedSession
  func revoke(_ session: StoredSession) async
}

/// Each session's client keeps `clientTiming`, and its transport `transportTiming`.
public struct HttpSessionFactory: SessionFactory {
  private let httpClient: HTTPClient
  private let clientTiming: ClientTiming
  private let transportTiming: TransportTiming
  private let clock: any Clock<Duration>
  private let random: RandomSource

  public init(
    httpClient: HTTPClient, clientTiming: ClientTiming = ClientTiming(),
    transportTiming: TransportTiming = TransportTiming(),
    clock: any Clock<Duration> = ContinuousClock(),
    random: any RandomNumberGenerator & Sendable = SystemRandomNumberGenerator()
  ) {
    self.httpClient = httpClient
    self.clientTiming = clientTiming
    self.transportTiming = transportTiming
    self.clock = clock
    self.random = RandomSource(random)
  }

  public func session(_ options: SessionFactoryOptions) async throws -> OpenedSession {
    let kb = options.kb
    return try await sessionFromKept(
      kb: KbTarget(id: kb.id, label: kb.label, endpoint: kb.endpoint),
      kept: keptIn(options.storage, kbId: kb.id), httpClient: httpClient,
      onAuthFailed: options.signals.notifySessionEnded, storage: options.storage,
      clientTiming: clientTiming, transportTiming: transportTiming, clock: clock, random: random)
  }

  public func revoke(_ session: StoredSession) async {
    guard let url = session.revocationEndpoint else { return }
    _ = try? await issuerAnswer(
      url, http: httpClient, clock: clock,
      form: [
        ("client_id", session.clientId), ("token", session.refresh),
        ("token_type_hint", "refresh_token"),
      ])
  }
}
