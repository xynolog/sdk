import Foundation
import Synchronization
import Testing

@testable import Xynolog
@testable import XynologTesting

// A worker's claims, told of an announcement its transport refused: it is still one received, so
// it is stamped as heard, and, since no filter can be compared with what cannot be read, it wakes
// the worker as a matching one would.

private func accepted() throws -> [JobFilter] {
  try decoded(
    [JobFilter].self,
    .array([
      .object(["jobType": .string("mark"), "params": .object(["motivation": .string("tagging")])])
    ]))
}

/// An announcement of `job` the transport refused, its payload being no object.
private func refusedAnnouncement(_ job: String) -> Carried {
  .refused(
    FrameRefusal(
      channel: Channels.jobQueued.name, member: "payload", reason: .malformed,
      payload: .string(job)))
}

private func claimsAsked(_ probe: ProbeTransport) -> Int {
  probe.calls.filter { $0.name == Operations.jobClaim.request.name }.count
}

private func nonePending() -> BusRequestError {
  BusRequestError(.busNonePending, "No pending job matches")
}

/// Until `holds` holds.
private func until(_ holds: @escaping @Sendable () async -> Bool) async throws {
  try await withinTestDeadline {
    while !(await holds()) { try await Task.sleep(for: .milliseconds(5)) }
  }
}

/// How many times it has been asked, this time among them.
private final class Answers: Sendable {
  private let count = Mutex(0)
  func next() -> Int {
    count.withLock {
      $0 += 1
      return $0
    }
  }
}

@Test func aRefusedAnnouncementIsHeardAndClaimsAsAMatchingOneDoes() async throws {
  let probe = ProbeTransport(channels: jobClaimChannels)
  let answers = Answers()
  probe.handle { name, _ in
    #expect(name == Operations.jobClaim.request.name)
    if answers.next() == 1 { throw nonePending() }
    return try jobClaimedFixture("job-8")
  }
  let client = try await XynologClient(transport: probe)
  defer { client.dispose() }
  let claims = client.job.claim(ClaimOptions(accepts: try accepted()))
  let reading = Task {
    var jobs = claims.makeAsyncIterator()
    return await jobs.next()?.jobId
  }
  try await until { claimsAsked(probe) == 1 }
  #expect(await claims.vitals.lastQueuedEventAt == nil)
  probe.deliver(refusedAnnouncement("job-8"))
  #expect(try await withinTestDeadline { await reading.value }?.value == "job-8")
  #expect(claimsAsked(probe) == 2)
  #expect(await claims.vitals.lastQueuedEventAt != nil)
  await claims.stop()
}

@Test func aHeldJobsHealthIsWhatItsEngineSaysToAWorkersHealthEndpoint() async throws {
  let probe = ProbeTransport(channels: jobClaimChannels)
  probe.handle { _, _ in try jobClaimedFixture("job-8") }
  let client = try await XynologClient(transport: probe)
  defer { client.dispose() }
  let claims = client.job.claim(ClaimOptions(accepts: try accepted()))
  let reading = Task {
    var jobs = claims.makeAsyncIterator()
    return await jobs.next()
  }
  let held = try #require(try await withinTestDeadline { await reading.value })
  let engine = Engine(provider: .ollama, model: "model")
  let health = await claims.health(of: engine)
  let read = try JSONDecoder().decode(WorkerEngineHealth.self, from: JSONEncoder().encode(health))
  #expect(read == health)
  #expect(health.engine == engine)
  #expect(health.jobs == (try accepted()))
  #expect(health.activeJob?.jobId == held.jobId)
  #expect(health.activeJob?.type == held.jobType)
  let claimedAt = try #require(health.lastClaimAt)
  #expect(try Date.ISO8601FormatStyle(includingFractionalSeconds: true).parse(claimedAt) <= Date())
  #expect(health.lastFinishedAt == nil)
  #expect(health.jobsCompleted == 0)
  await claims.stop()
}

// Claims' health copies the vitals into the health member by member. Every member of the vitals,
// each set to a value of its own, arrives in the health; the vitals are held to have every member
// set, so they grow with the type.
@Test func aWorkersHealthCarriesEveryMemberOfItsVitals() throws {
  let vitals = WorkerVitals(
    lastQueuedEventAt: "2026-11-25T00:00:01.000Z", lastClaimAt: "2026-11-25T00:00:02.000Z",
    lastFinishedAt: "2026-11-25T00:00:03.000Z", lastActivityAt: "2026-11-25T00:00:04.000Z",
    activeJob: WorkerActiveJob(
      jobId: try JobId("job-1"), type: .mark, since: "2026-11-25T00:00:05.000Z"),
    jobsCompleted: 6)
  let members = Mirror(reflecting: vitals).children
  for member in members {
    let value = Mirror(reflecting: member.value)
    #expect(
      value.displayStyle != .optional || !value.children.isEmpty, "\(member.label ?? "") is set")
  }
  let said = try wirePayload(vitals)
  #expect(said.count == members.count)
  let health = try wirePayload(
    Claims.health(vitals, of: Engine(provider: .ollama, model: "model"), jobs: []))
  for (name, value) in said { #expect(health[name] == value, "\(name) arrives") }
}

@Test func aRefusedAnnouncementWhileAClaimIsInFlightEarnsOneMoreClaim() async throws {
  let probe = ProbeTransport(channels: jobClaimChannels)
  let answers = Answers()
  let answer = Watched(false)
  probe.handle { _, _ in
    if answers.next() == 1 {
      for await given in answer where given { break }
    }
    throw nonePending()
  }
  let client = try await XynologClient(transport: probe)
  defer { client.dispose() }
  let claims = client.job.claim(ClaimOptions(accepts: try accepted()))
  let reading = Task {
    var jobs = claims.makeAsyncIterator()
    _ = await jobs.next()
  }
  try await until { claimsAsked(probe) == 1 }
  probe.deliver(refusedAnnouncement("job-9"))
  try await until { await claims.vitals.lastQueuedEventAt != nil }
  #expect(claimsAsked(probe) == 1, "one claim is in flight at a time")
  answer.set(true)
  try await until { claimsAsked(probe) == 2 }
  reading.cancel()
  await claims.stop()
}

@Test func aRefusedAnnouncementWhileAJobIsHeldIsHeardAndIgnored() async throws {
  let probe = ProbeTransport(channels: jobClaimChannels)
  let answers = Answers()
  probe.handle { _, _ in
    if answers.next() == 1 { return try jobClaimedFixture("job-1") }
    throw nonePending()
  }
  let client = try await XynologClient(transport: probe)
  defer { client.dispose() }
  let claims = client.job.claim(ClaimOptions(accepts: try accepted()))
  var jobs = claims.makeAsyncIterator()
  let job = try #require(await jobs.next())
  probe.deliver(refusedAnnouncement("job-8"))
  try await until { await claims.vitals.lastQueuedEventAt != nil }
  #expect(claimsAsked(probe) == 1)
  try await job.fail("done", failure: nil)
  try await until { claimsAsked(probe) == 2 }
  await claims.stop()
  #expect(claimsAsked(probe) == 2, "the settle claims, and nothing was owed")
}

// ── What is kept for a first listener ───────────────────────────────────

/// The refusal of the `n`th claim.
private func refusal(_ n: Int) -> BusRequestError { BusRequestError(.busRejected, "refusal \(n)") }

/// Claims over `probe` whose first `refused` claims are refused, each with its own refusal, and
/// whose next is answered with job-1; nobody listens to their refusals. Each refused claim, an
/// announcement asks for the next. Each refusal is said before the next claim is asked, so all
/// are said once job-1 is handed out, which is when this returns.
private func claimsRefused(_ refused: Int, over probe: ProbeTransport, client: XynologClient)
  async throws -> Claims
{
  let answers = Answers()
  probe.handle { name, _ in
    guard name == Operations.jobClaim.request.name else { throw nonePending() }
    let answer = answers.next()
    if answer > refused { return try jobClaimedFixture("job-1") }
    throw refusal(answer)
  }
  let claims = client.job.claim(ClaimOptions(accepts: try accepted()))
  let reading = Task {
    var jobs = claims.makeAsyncIterator()
    return await jobs.next()?.jobId
  }
  for asked in 1...refused {
    try await until { claimsAsked(probe) == asked }
    probe.deliver(refusedAnnouncement("job-\(asked)"))
  }
  #expect(try await withinTestDeadline { await reading.value }?.value == "job-1")
  return claims
}

/// What each refusal `refusals` hands out says of itself, until they end.
private func everyRefusal(_ refusals: Events<ClaimRefusal>) async throws -> [String] {
  try await withinTestDeadline {
    var heard: [String] = []
    for try await refused in refusals { heard.append(refused.message) }
    return heard
  }
}

@Test func claimsNobodyListenedToKeepTheLatestRefusalsForTheirFirstListener() async throws {
  let probe = ProbeTransport(channels: jobClaimChannels)
  let client = try await XynologClient(transport: probe)
  defer { client.dispose() }
  let beyond = 5
  let refused = Timings.errorsKeptForFirstReaderCount + beyond
  let claims = try await claimsRefused(refused, over: probe, client: client)
  let refusals = claims.refused()
  await claims.stop()
  let latest = ((beyond + 1)...refused).map { String(describing: refusal($0)) }
  #expect(try await everyRefusal(refusals) == latest)
}

@Test func aFirstListenerWhoComesAfterTheClaimsHaveStoppedHearsNothing() async throws {
  let probe = ProbeTransport(channels: jobClaimChannels)
  let client = try await XynologClient(transport: probe)
  defer { client.dispose() }
  let claims = try await claimsRefused(1, over: probe, client: client)
  await claims.stop()
  #expect(try await everyRefusal(claims.refused()) == [])
}

/// How often the claims look for a stall; a held job is stalled once it has been silent for less.
private let stallCheck = Duration.milliseconds(2)

/// Claims over `probe` that answer every claim with the next job, job-1 first, and call a held job
/// stalled once it has been silent for longer than a millisecond.
private func claimsOfJobs(over probe: ProbeTransport, client: XynologClient) throws -> Claims {
  let answers = Answers()
  probe.handle { name, _ in
    guard name == Operations.jobClaim.request.name else { throw nonePending() }
    return try jobClaimedFixture("job-\(answers.next())")
  }
  return client.job.claim(
    ClaimOptions(accepts: try accepted(), heldJobStallMs: 1, heldJobStallCheckMs: 2))
}

/// Until the claims wait on `clock` to look for a stall again: the look they took when the clock
/// last moved is done.
private func looking(on clock: TestClock) async throws {
  try await until { clock.wakes.contains(clock.now.advanced(by: stallCheck)) }
}

/// Takes the next job `jobs` hands out, leaves it silent until the claims have looked at it and
/// called it stalled, and fails it, which claims the next. The job's id.
private func stallTheNext(_ jobs: inout Claims.AsyncIterator, on clock: TestClock) async throws
  -> String
{
  let job = try #require(await jobs.next())
  try await looking(on: clock)
  clock.advance(by: stallCheck)
  try await looking(on: clock)
  try await job.fail("stalled", failure: nil)
  return job.jobId.value
}

/// The job each stall `stalls` hands out names, until they end.
private func everyStall(_ stalls: Events<HeldJobStall>) async throws -> [String] {
  try await withinTestDeadline {
    var heard: [String] = []
    for try await stall in stalls { heard.append(stall.jobId.value) }
    return heard
  }
}

@Test func claimsNobodyListenedToKeepTheLatestStallsForTheirFirstListener() async throws {
  let clock = TestClock()
  let probe = ProbeTransport(channels: jobClaimChannels)
  let client = try await XynologClient(transport: probe, clock: clock)
  defer { client.dispose() }
  let claims = try claimsOfJobs(over: probe, client: client)
  var jobs = claims.makeAsyncIterator()
  let beyond = 5
  var stalled: [String] = []
  for _ in 0..<(Timings.errorsKeptForFirstReaderCount + beyond) {
    stalled.append(try await stallTheNext(&jobs, on: clock))
  }
  let first = claims.stalled()
  let later = claims.stalled()
  let last = try await stallTheNext(&jobs, on: clock)
  await claims.stop()
  let firstHeard = try await everyStall(first)
  let laterHeard = try await everyStall(later)
  #expect(firstHeard == Array(stalled.dropFirst(beyond)) + [last])
  #expect(laterHeard == [last], "a later listener hears only what follows it")
}

@Test func aFirstListenerWhoComesAfterTheClaimsHaveStoppedHearsOfNoStall() async throws {
  let clock = TestClock()
  let probe = ProbeTransport(channels: jobClaimChannels)
  let client = try await XynologClient(transport: probe, clock: clock)
  defer { client.dispose() }
  let claims = try claimsOfJobs(over: probe, client: client)
  var jobs = claims.makeAsyncIterator()
  _ = try await stallTheNext(&jobs, on: clock)
  await claims.stop()
  #expect(try await everyStall(claims.stalled()) == [])
}
