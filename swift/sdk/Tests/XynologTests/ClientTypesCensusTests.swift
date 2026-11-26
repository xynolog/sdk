import Foundation
import Testing

@testable import Xynolog

// SearchState, JobEvent and CacheState, generic and written by hand, held to their schemas in
// protocol/specs/src/client/types: a member or a branch either side gains or loses fails.

private func properties(_ schema: JSONValue) throws -> Set<String> {
  Set(try required(schema.object, "properties").object.keys)
}

@Test func searchStateHasTheSchemasMembers() throws {
  let written = try encoded(SearchState<Int>(results: [], isSearching: false)).object
  #expect(Set(written.keys) == (try properties(Spec.read("client/types/SearchState.json"))))
}

/// One event of each case; the switch fails to compile on a case JobEvent gains, for a sample of it.
private func events() throws -> [JobEvent<Int>] {
  let job = JSONValue.string("job-1")
  let samples: [JobEvent<Int>] = [
    .created(try decoded(JobCreatedResultResponse.self, .object(["jobId": job]))),
    .progress(JobProgress(percentage: 50)),
    .failed(
      try decoded(
        JobFailCommand.self,
        .object([
          "resourceId": .string("res-1"), "jobId": job, "jobType": .string("mark"),
          "error": .string("failed"),
        ]))),
    .refused(RefusedFrame(channel: "", member: "", reason: .lacks)),
    .complete(0),
  ]
  for sample in samples {
    switch sample {
    case .created, .progress, .failed, .refused, .complete: break
    }
  }
  return samples
}

@Test func jobEventHasTheSchemasBranchesEachOfOneDatum() throws {
  let branches = try required(Spec.read("client/types/JobEvent.json").object, "oneOf").array
  var told: [String: JSONValue] = [:]
  for branch in branches {
    let kind = try required(required(branch.object, "properties").object, "kind")
    told[try required(kind.object, "enum").array[0].text] = branch
    #expect(try properties(branch) == ["kind", "data"])
  }
  let written = try events()
  let cases = written.compactMap { Mirror(reflecting: $0).children.first?.label }
  #expect(Set(cases) == Set(told.keys))
  #expect(written.count == told.count)
  let data = try required(required(#require(told["refused"]).object, "properties").object, "data")
  let refused = RefusedFrame(channel: "", member: "", reason: .lacks)
  #expect(Set(Mirror(reflecting: refused).children.compactMap(\.label)) == (try properties(data)))
}

private struct CacheFailure: Error {}

/// Each state's status and the members it holds. A payload-less case has no label to read, so the
/// switch names each, and fails to compile on a case CacheState gains.
private func told(_ state: CacheState<Int>) -> (status: String, members: Set<String>) {
  switch state {
  case .pending: ("pending", ["status"])
  case .ready: ("ready", ["status", "value"])
  case .failed: ("failed", ["status", "error"])
  }
}

@Test func cacheStateHasTheSchemasBranchesEachOfItsMembers() throws {
  let branches = try required(Spec.read("client/types/CacheState.json").object, "oneOf").array
  var held: [String: Set<String>] = [:]
  for branch in branches {
    let status = try required(required(branch.object, "properties").object, "status")
    held[try required(status.object, "enum").array[0].text] = try properties(branch)
  }
  let written = [CacheState<Int>.pending, .ready(0), .failed(CacheFailure())].map(told)
  #expect(Dictionary(uniqueKeysWithValues: written.map { ($0.status, $0.members) }) == held)
}
