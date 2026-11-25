import Foundation
import Synchronization

/// Each wait a claiming keeps: the one its options name, else client/timing.json's of that name.
extension ClaimOptions {
  var claimTimeoutMs: Int { jobClaimTimeoutMs ?? Timings.jobClaimTimeoutMs }
  var stallMs: Int { heldJobStallMs ?? Timings.heldJobStallMs }
  var stallCheckMs: Int { max(1, heldJobStallCheckMs ?? Timings.heldJobStallCheckMs) }
  var commitTimeoutMs: Int { markCommitTimeoutMs ?? Timings.markCommitTimeoutMs }
}

public struct ClaimRefusal: Error, Sendable {
  public let code: BusRequestErrorCode?
  public let detail: String
}

public struct ActiveJob: Encodable, Sendable {
  public let jobId: JobId
  public let jobType: JobType
  public let since: Date
}

public struct WorkerVitals: Encodable, Sendable {
  public internal(set) var lastQueuedEventAt: Date?
  public internal(set) var lastClaimAt: Date?
  public internal(set) var lastFinishedAt: Date?
  public internal(set) var lastActivityAt: Date?
  public internal(set) var activeJob: ActiveJob?
  public internal(set) var jobsCompleted = 0
}

public struct HeldJobStall: Sendable {
  public let jobId: JobId
  public let jobType: JobType
  public let heldSince: Date
  public let lastActivityAt: Date
  public let silentFor: Duration
  public let threshold: Duration
}

public func jobMatchesFilter(_ filter: JSONValue, job: JSONValue) -> Bool {
  guard case .object = filter else { return false }
  return jobStates(filter, actual: job)
}

private func jobStates(_ expected: JSONValue, actual: JSONValue) -> Bool {
  if case .object(let fields) = expected {
    guard case .object(let object) = actual else { return false }
    return fields.allSatisfy { key, value in
      guard let observed = object[key] else { return false }
      return jobStates(value, actual: observed)
    }
  }
  return expected == actual
}

public func willRetryAfter(retryCount: Int, maxRetries: Int, failureClass: FailureClass?) -> Bool {
  guard retryCount < maxRetries else { return false }
  switch failureClass {
  case nil, .transient: return true
  case .deterministic, .withheld: return false
  }
}

/// Claims wake when the stream opens, a matching announcement arrives, or the held job settles.
public actor Claims: AsyncSequence {
  public typealias Element = any HeldJob
  private let transport: any Transport
  private let options: ClaimOptions
  private let clock: any Clock<Duration>
  private let command: JobClaimCommand
  private let filters: [JSONValue]
  private let stream: AsyncStream<any HeldJob>
  private let jobs: AsyncStream<any HeldJob>.Continuation
  private let refusals = Broadcast<ClaimRefusal>(keepingForFirst: true)
  private let stalls = Broadcast<HeldJobStall>(keepingForFirst: true)
  private var currentVitals = WorkerVitals()
  public var vitals: WorkerVitals { currentVitals }

  /// What `engine`, claiming with these claims, says of itself to a worker's health endpoint: the
  /// engine, the jobs the claims accept, and their vitals.
  public func health(of engine: Engine) -> WorkerEngineHealth {
    let vitals = currentVitals
    return WorkerEngineHealth(
      engine: engine, jobs: options.accepts,
      lastQueuedEventAt: vitals.lastQueuedEventAt.map(dateTime),
      lastClaimAt: vitals.lastClaimAt.map(dateTime),
      lastFinishedAt: vitals.lastFinishedAt.map(dateTime),
      lastActivityAt: vitals.lastActivityAt.map(dateTime),
      activeJob: vitals.activeJob.map {
        WorkerEngineHealthActiveJob(jobId: $0.jobId, type: $0.jobType, since: dateTime($0.since))
      },
      jobsCompleted: vitals.jobsCompleted)
  }

  private let iterated = Mutex(false)
  private var readers: [Task<Void, Never>] = []
  private var claimTask: Task<Void, Never>?
  private var held: (any WorkerLease)?
  private var wakeOwed = false
  private var open = false
  private var stopped = false
  private var stopping: Task<Void, Never>?
  private var sinceActivity: (@Sendable () -> Duration)?
  private var stallReported = false

  init(
    options: ClaimOptions, transport: any Transport, lifetime: Lifetime, clock: any Clock<Duration>
  ) {
    self.command = JobClaimCommand(accepts: options.accepts)
    self.filters = options.accepts.compactMap { filter in
      (try? wirePayload(filter)).map(JSONValue.object)
    }
    self.transport = transport
    self.options = options
    self.clock = clock
    (self.stream, self.jobs) = AsyncStream.makeStream()
    lifetime.onEnd { [weak self] in spawn { await self?.abandon() } }
  }

  deinit {
    for reader in readers { reader.cancel() }
    claimTask?.cancel()
    jobs.finish()
    refusals.finish()
    stalls.finish()
  }

  public struct AsyncIterator: AsyncIteratorProtocol {
    fileprivate let owner: Claims?
    fileprivate var reader: AsyncStream<any HeldJob>.Iterator?
    public mutating func next() async -> (any HeldJob)? {
      guard let owner, !Task.isCancelled else { return nil }
      await owner.begin()
      return await reader?.next()
    }
  }

  public nonisolated func makeAsyncIterator() -> AsyncIterator {
    let first = iterated.withLock { taken in
      if taken { return false }
      taken = true
      return true
    }
    return AsyncIterator(
      owner: first ? self : nil, reader: first ? stream.makeAsyncIterator() : nil)
  }

  /// Each claim that was refused for a reason other than nothing pending. The first listener is
  /// given first the latest `Timings.errorsKeptForFirstReaderCount` refused before it listened;
  /// one who comes after the claims have ended, nothing.
  public nonisolated func refused() -> Events<ClaimRefusal> { refusals.listen() }

  /// Each held job that showed no activity for longer than `ClaimOptions.heldJobStallMs`, once for each
  /// job. The first listener is given first the latest `Timings.errorsKeptForFirstReaderCount`
  /// stalled before it listened; one who comes after the claims have ended, nothing.
  public nonisolated func stalled() -> Events<HeldJobStall> { stalls.listen() }

  private func begin() async {
    guard readers.isEmpty, !stopped else { return }
    let transport = transport
    let options = options
    let clock = clock
    readers.append(
      spawn { [weak self] in
        do {
          let frames = try await transport.frames([
            Channels.jobQueued.name, Channels.jobCancelRequested.name,
          ])
          defer { frames.dispose() }
          await self?.listenToState()
          for try await carried in frames { await self?.hear(carried) }
        } catch {
          if !Task.isCancelled { await self?.refuse(error) }
        }
        if !Task.isCancelled { await self?.abandon() }
      })
    readers.append(
      spawn { [weak self] in
        while !Task.isCancelled {
          do { try await sleepMilliseconds(options.stallCheckMs, on: clock) } catch { return }
          await self?.checkStall()
        }
      })
  }

  private func listenToState() {
    guard !stopped else { return }
    let transport = transport
    readers.append(
      spawn { [weak self] in
        for await state in transport.state {
          if Task.isCancelled { return }
          await self?.connection(state)
        }
      })
  }

  private func connection(_ state: ConnectionState) {
    let previous = open
    open = state == .open
    if open, !previous { pull() }
    if state == .closed { abandon() }
  }

  private func hear(_ carried: Carried) async {
    guard !stopped else { return }
    if carried.channel == Channels.jobQueued.name {
      currentVitals.lastQueuedEventAt = Date()
      let wakes =
        switch carried {
        case .frame(let frame):
          filters.contains(where: { jobMatchesFilter($0, job: .object(frame.payload)) })
        // No filter can be compared with what cannot be read: a refused announcement counts as one
        // that matches.
        case .refused: true
        }
      if wakes { pull() }
    } else if case .frame(let frame) = carried, case .string(let id) = frame.payload["jobId"],
      let held, held.jobId.value == id
    {
      await held.signalCancellation()
    }
  }

  private func pull() {
    guard !stopped, open, held == nil else { return }
    if claimTask != nil {
      wakeOwed = true
      return
    }
    wakeOwed = false
    let transport = transport
    let command = command
    let options = options
    let clock = clock
    claimTask = spawn { [weak self] in
      do {
        let frame = try await resultOf(
          Operations.jobClaim.request.name, wirePayload(command), over: transport,
          timeoutMs: options.claimTimeoutMs, clock: clock, parent: [:])
        let answer = try JSONDecoder().decode(
          JobClaimedResult.self, from: JSONEncoder().encode(frame.payload))
        await self?.take(answer.response, trace: frame.trace)
      } catch {
        if !Task.isCancelled { await self?.refuse(error) }
      }
      await self?.claimFinished()
    }
  }

  private func take(_ record: JobRunning, trace: [String: String]?) async {
    let job: any WorkerLease
    switch record.metadata.type {
    case .mark:
      job = HeldWork<MarkJobResult>(
        record: record, trace: trace, transport: transport, owner: self, options: options,
        clock: clock)
    case .yield:
      job = HeldWork<YieldJobResult>(
        record: record, trace: trace, transport: transport, owner: self, options: options,
        clock: clock)
    }
    if stopped {
      try? await job.fail(
        "The worker stopped while it held the job", failureClass: nil, completedUnits: nil,
        unitCursors: nil)
      return
    }
    held = job
    let now = Date()
    currentVitals.lastClaimAt = now
    currentVitals.activeJob = ActiveJob(jobId: job.jobId, jobType: job.jobType, since: now)
    active()
    stallReported = false
    wakeOwed = false
    jobs.yield(job)
  }

  private func refuse(_ error: any Error) {
    guard !stopped else { return }
    let code = (error as? BusRequestError)?.reason
    if code != .busNonePending {
      refusals.yield(ClaimRefusal(code: code, detail: String(describing: error)))
    }
  }

  private func claimFinished() {
    claimTask = nil
    if wakeOwed { pull() }
  }

  func active() {
    sinceActivity = stopwatch(clock)
    currentVitals.lastActivityAt = Date()
  }

  func released(_ job: any WorkerLease, completed: Bool) {
    guard held === job else { return }
    held = nil
    active()
    currentVitals.lastFinishedAt = currentVitals.lastActivityAt
    currentVitals.activeJob = nil
    if completed { currentVitals.jobsCompleted += 1 }
    pull()
  }

  private func checkStall() {
    guard !stopped, !stallReported, let job = currentVitals.activeJob, let sinceActivity,
      let lastActivityAt = currentVitals.lastActivityAt
    else { return }
    let silence = sinceActivity()
    let threshold = Duration.milliseconds(options.stallMs)
    if silence > threshold {
      stallReported = true
      stalls.yield(
        HeldJobStall(
          jobId: job.jobId, jobType: job.jobType, heldSince: job.since,
          lastActivityAt: lastActivityAt, silentFor: silence, threshold: threshold))
    }
  }

  public func stop() async {
    if let stopping {
      await stopping.value
      abandon()
      return
    }
    guard !stopped else { return }
    stopped = true
    let job = held
    let pending = claimTask
    let finish = spawn {
      if let job {
        try? await job.fail(
          "The worker stopped while it held the job", failureClass: nil, completedUnits: nil,
          unitCursors: nil)
      }
      await pending?.value
    }
    stopping = finish
    await finish.value
    abandon()
  }

  private func abandon() {
    stopped = true
    for reader in readers { reader.cancel() }
    readers.removeAll()
    claimTask?.cancel()
    claimTask = nil
    held = nil
    currentVitals.activeJob = nil
    jobs.finish()
    refusals.finish()
    stalls.finish()
  }
}
