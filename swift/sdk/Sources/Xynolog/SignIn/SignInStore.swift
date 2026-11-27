import Foundation

#if canImport(Darwin)
  import Darwin
#else
  import Glibc
#endif

public final class SignInStore: Sendable {
  private let path: URL
  public init(path: URL) { self.path = path.standardizedFileURL }
  public func entry(_ key: String) -> any SignInKept { StoreEntry(store: self, key: key) }
  public func read() throws -> [String: JSONValue] {
    do {
      return try JSONDecoder().decode([String: JSONValue].self, from: Data(contentsOf: path))
    } catch let error as CocoaError where error.code == .fileReadNoSuchFile { return [:] }
  }
  func change<Value>(_ action: (inout [String: JSONValue]) throws -> (Value, Bool)) throws -> Value
  {
    let directory = path.deletingLastPathComponent()
    guard let directoryMode = mode_t(ownerOnlyDirectory.value, radix: 8),
      let fileMode = mode_t(ownerOnlyFile.value, radix: 8)
    else {
      preconditionFailure("Invalid owner-only modes")
    }
    try FileManager.default.createDirectory(
      at: directory, withIntermediateDirectories: true,
      attributes: [.posixPermissions: NSNumber(value: directoryMode)])
    let lock = directory.appendingPathComponent(signInLockName)
    let fd = open(lock.path, O_CREAT | O_RDWR, fileMode)
    guard fd >= 0 else { throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO) }
    defer { _ = close(fd) }
    while flock(fd, LOCK_EX) != 0 {
      if errno != EINTR { throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO) }
    }
    defer { _ = flock(fd, LOCK_UN) }
    guard chmod(directory.path, directoryMode) == 0, fchmod(fd, fileMode) == 0 else {
      throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
    }
    var document = try read()
    let (value, changed) = try action(&document)
    if changed {
      let temporary = directory.appendingPathComponent(
        path.lastPathComponent + "." + UUID().uuidString + ".tmp")
      let output = open(temporary.path, O_CREAT | O_EXCL | O_WRONLY, fileMode)
      guard output >= 0 else { throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO) }
      let handle = FileHandle(fileDescriptor: output, closeOnDealloc: true)
      defer { try? FileManager.default.removeItem(at: temporary) }
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
      var data = try encoder.encode(document)
      data.append(10)
      try handle.write(contentsOf: data)
      try handle.synchronize()
      try handle.close()
      guard rename(temporary.path, path.path) == 0 else {
        throw POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
      }
    }
    return value
  }
}
private struct StoreEntry: SignInKept {
  let store: SignInStore
  let key: String
  /// A member of the document as a sign-in: nil for one with a fault as the table holds a sign-in
  /// to (an empty token, a member it lacks).
  private func decoded(_ value: JSONValue?) -> SignIn? {
    guard let value else { return nil }
    return readAs(SignIn.self, value)
  }
  func held() async throws -> StoredSession? {
    try await spawnDetached { try self.heldNow() }.value
  }
  private func heldNow() throws -> StoredSession? {
    guard let entry = try decoded(store.read()[key]), let refresh = entry.refreshToken,
      !refresh.isEmpty
    else { return nil }
    return StoredSession(
      access: entry.token, refresh: refresh, clientId: scriptClientID,
      tokenEndpoint: entry.tokenEndpoint, revocationEndpoint: entry.revocationEndpoint)
  }
  private func written(_ before: SignIn, access: String, refresh: String) throws -> JSONValue {
    var entry = before
    entry.token = access
    entry.refreshToken = refresh
    entry.obtainedAt = Date().formatted(.iso8601)
    entry.expiresAt = tokenExpiry(access).map {
      Date(timeIntervalSince1970: $0).formatted(.iso8601)
    }
    return try JSONDecoder().decode(JSONValue.self, from: JSONEncoder().encode(entry))
  }
  func keep(_ signIn: StoredSession) async throws {
    guard signIn.clientId == scriptClientID else {
      throw SignInError(.exchange, "The sign-in store requires the script OAuth client")
    }
    guard let issuer = textClaim(signIn.access, name: "iss") else {
      throw SignInError(.exchange, "The access token names no issuer")
    }
    let learned = SignIn(
      token: signIn.access, email: textClaim(signIn.access, name: "email"),
      obtainedAt: Date().formatted(.iso8601), issuer: issuer,
      tokenEndpoint: signIn.tokenEndpoint, revocationEndpoint: signIn.revocationEndpoint)
    let value = try written(learned, access: signIn.access, refresh: signIn.refresh)
    try await spawnDetached {
      try store.change { document in
        document[key] = value
        return ((), true)
      }
    }.value
  }
  func renewed(read: StoredSession, access: String, refresh: String) async throws -> String? {
    try await spawnDetached {
      try store.change { document -> (String?, Bool) in
        guard let before = decoded(document[key]) else { return (nil, false) }
        guard before.token == read.access, before.refreshToken == read.refresh else {
          return (before.token, false)
        }
        document[key] = try written(before, access: access, refresh: refresh)
        return (access, true)
      }
    }.value
  }
  /// The sign-in store keeps no person: it cannot record one.
  func recordPersonKey(holding access: String, _ personKey: String) -> Bool { false }
  func forget() async throws {
    try await spawnDetached {
      try store.change { document in ((), document.removeValue(forKey: key) != nil) }
    }.value
  }
}
