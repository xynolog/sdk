// Generated from protocol/specs/src/openapi.json and its paths; do not edit.
// Regenerate: make generate (codegen/lib/gateway_http/swift.ml)
import Foundation

/// An operation of the gateway: its method, and its path, a `{name}` for each parameter, which the
/// caller fills.
public struct GatewayRoute: Sendable {
  public let method: String
  public let path: String
  /// `getHealth`.
  public static let getHealth = GatewayRoute(method: "GET", path: "/api/health")
  /// `getHealthAtRoot`.
  public static let getHealthAtRoot = GatewayRoute(method: "GET", path: "/")
  /// `getOpenApiDocument`.
  public static let getOpenApiDocument = GatewayRoute(method: "GET", path: "/api/openapi.json")
  /// `getProtectedResourceMetadata`.
  public static let getProtectedResourceMetadata = GatewayRoute(
    method: "GET", path: "/.well-known/oauth-protected-resource")
  /// `createMediaToken`.
  public static let createMediaToken = GatewayRoute(method: "POST", path: "/api/tokens/media")
  /// `getCurrentUser`.
  public static let getCurrentUser = GatewayRoute(method: "GET", path: "/api/users/me")
  /// `getStatus`.
  public static let getStatus = GatewayRoute(method: "GET", path: "/api/status")
  /// `subscribeToBus`.
  public static let subscribeToBus = GatewayRoute(method: "POST", path: "/bus/subscribe")
  /// `emitOnBus`.
  public static let emitOnBus = GatewayRoute(method: "POST", path: "/bus/emit")
  /// `uploadResource`.
  public static let uploadResource = GatewayRoute(method: "POST", path: "/resources")
  /// `getResourceRepresentation`.
  public static let getResourceRepresentation = GatewayRoute(method: "GET", path: "/resources/{id}")
  /// `getResourceJsonLd`.
  public static let getResourceJsonLd = GatewayRoute(method: "GET", path: "/resources/{id}/jsonld")
  /// `getResourceAnnotations`.
  public static let getResourceAnnotations = GatewayRoute(
    method: "GET", path: "/resources/{id}/annotations")
  /// `getResourceAnchoredText`.
  public static let getResourceAnchoredText = GatewayRoute(
    method: "GET", path: "/resources/{id}/anchored-text")
  /// `getResourceRepresentationWithMediaToken`.
  public static let getResourceRepresentationWithMediaToken = GatewayRoute(
    method: "GET", path: "/api/resources/{id}")
}

/// An operation of the archivist: its method, and its path, a `{name}` for each parameter, which
/// the caller fills.
public struct ArchivistRoute: Sendable {
  public let method: String
  public let path: String
  /// `getHealth`.
  public static let getHealth = ArchivistRoute(method: "GET", path: "/health")
  /// `listStreams`.
  public static let listStreams = ArchivistRoute(method: "GET", path: "/events")
  /// `getResourceEvents`.
  public static let getResourceEvents = ArchivistRoute(method: "GET", path: "/events/{resourceId}")
  /// `storeResource`.
  public static let storeResource = ArchivistRoute(method: "POST", path: "/resources")
  /// `getResourceContent`.
  public static let getResourceContent = ArchivistRoute(
    method: "GET", path: "/resources/{id}/content")
  /// `getResourceJsonLd`.
  public static let getResourceJsonLd = ArchivistRoute(
    method: "GET", path: "/resources/{id}/jsonld")
  /// `getResourceAnnotations`.
  public static let getResourceAnnotations = ArchivistRoute(
    method: "GET", path: "/resources/{id}/annotations")
  /// `getResourceAnchoredText`.
  public static let getResourceAnchoredText = ArchivistRoute(
    method: "GET", path: "/resources/{id}/anchored-text")
  /// `putResourceAnchoredText`.
  public static let putResourceAnchoredText = ArchivistRoute(
    method: "PUT", path: "/resources/{id}/anchored-text")
  /// `listAnchoredTextEntries`.
  public static let listAnchoredTextEntries = ArchivistRoute(
    method: "GET", path: "/anchored-text/entries")
  /// `getStoredResourceAnchoredText`.
  public static let getStoredResourceAnchoredText = ArchivistRoute(
    method: "GET", path: "/resources/{id}/anchored-text/stored")
  /// `putAnchoredTextStamp`.
  public static let putAnchoredTextStamp = ArchivistRoute(
    method: "PUT", path: "/anchored-text/stamp")
}

/// The media type each operation sends and answers with, where it has a body.
public enum GatewayMedia {
  public static let getHealthAnswers = "application/json"
  public static let getHealthAtRootAnswers = "application/json"
  public static let getOpenApiDocumentAnswers = "application/json"
  public static let getProtectedResourceMetadataAnswers = "application/json"
  public static let createMediaTokenSends = "application/json"
  public static let createMediaTokenAnswers = "application/json"
  public static let getCurrentUserAnswers = "application/json"
  public static let getStatusAnswers = "application/json"
  public static let subscribeToBusSends = "application/json"
  public static let subscribeToBusAnswers = "text/event-stream"
  public static let emitOnBusSends = "application/json"
  public static let emitOnBusAnswers = "application/json"
  public static let uploadResourceSends = "multipart/form-data"
  public static let uploadResourceAnswers = "application/json"
  public static let getResourceRepresentationAnswers = "*/*"
  public static let getResourceJsonLdAnswers = "application/ld+json"
  public static let getResourceAnnotationsAnswers = "application/json"
  public static let getResourceAnchoredTextAnswers = "application/json"
  public static let getResourceRepresentationWithMediaTokenAnswers = "*/*"
}

/// Each header the gateway's operations name, asked or answered.
public enum GatewayHeader {
  public static let cacheControl = "Cache-Control"
  public static let idempotencyKey = "Idempotency-Key"
  public static let link = "Link"
  public static let retryAfter = "Retry-After"
  public static let wwwAuthenticate = "WWW-Authenticate"
}

/// A member of an upload (`ResourceUpload`), by the name it is sent under.
public enum UploadField: String, Sendable, CaseIterable {
  case name
  case file
  case format
  case storageUri
  case language
  case entityTypes
  case sourceAnnotationId
  case sourceResourceId
  case generationPrompt
  case generator
  case jobId
  case isDraft
  case cloneToken
  case archiveOriginal
}

/// The form a service account posts with a client secret, each member by its name, in the schema's
/// order.
public func clientSecretForm(clientId: String, clientSecret: String) -> [(String, String)] {
  return [
    ("grant_type", "client_credentials"), ("client_id", clientId), ("client_secret", clientSecret),
  ]
}
