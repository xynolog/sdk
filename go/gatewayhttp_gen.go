// Code generated from protocol/specs/src/openapi.json and its paths; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/gateway_http/go.ml)

package xynolog

import "net/url"

// GatewayRoute is an operation of the gateway: its method and its path, a
// {name} for each parameter, which the caller fills.
type GatewayRoute struct {
	Method, Path string
}

// RouteGetHealth is getHealth.
var RouteGetHealth = GatewayRoute{Method: "GET", Path: "/api/health"}

// RouteGetHealthAtRoot is getHealthAtRoot.
var RouteGetHealthAtRoot = GatewayRoute{Method: "GET", Path: "/"}

// RouteGetOpenApiDocument is getOpenApiDocument.
var RouteGetOpenApiDocument = GatewayRoute{Method: "GET", Path: "/api/openapi.json"}

// RouteGetProtectedResourceMetadata is getProtectedResourceMetadata.
var RouteGetProtectedResourceMetadata = GatewayRoute{Method: "GET", Path: "/.well-known/oauth-protected-resource"}

// RouteCreateMediaToken is createMediaToken.
var RouteCreateMediaToken = GatewayRoute{Method: "POST", Path: "/api/tokens/media"}

// RouteGetCurrentUser is getCurrentUser.
var RouteGetCurrentUser = GatewayRoute{Method: "GET", Path: "/api/users/me"}

// RouteGetStatus is getStatus.
var RouteGetStatus = GatewayRoute{Method: "GET", Path: "/api/status"}

// RouteSubscribeToBus is subscribeToBus.
var RouteSubscribeToBus = GatewayRoute{Method: "POST", Path: "/bus/subscribe"}

// RouteEmitOnBus is emitOnBus.
var RouteEmitOnBus = GatewayRoute{Method: "POST", Path: "/bus/emit"}

// RouteUploadResource is uploadResource.
var RouteUploadResource = GatewayRoute{Method: "POST", Path: "/resources"}

// RouteGetResourceRepresentation is getResourceRepresentation.
var RouteGetResourceRepresentation = GatewayRoute{Method: "GET", Path: "/resources/{id}"}

// RouteGetResourceJsonLd is getResourceJsonLd.
var RouteGetResourceJsonLd = GatewayRoute{Method: "GET", Path: "/resources/{id}/jsonld"}

// RouteGetResourceAnnotations is getResourceAnnotations.
var RouteGetResourceAnnotations = GatewayRoute{Method: "GET", Path: "/resources/{id}/annotations"}

// RouteGetResourceAnchoredText is getResourceAnchoredText.
var RouteGetResourceAnchoredText = GatewayRoute{Method: "GET", Path: "/resources/{id}/anchored-text"}

// RouteGetResourceRepresentationWithMediaToken is
// getResourceRepresentationWithMediaToken.
var RouteGetResourceRepresentationWithMediaToken = GatewayRoute{Method: "GET", Path: "/api/resources/{id}"}

// The media type each operation sends and answers with, where it has a body.
const (
	routeGetHealthAnswers                               = "application/json"
	routeGetHealthAtRootAnswers                         = "application/json"
	routeGetOpenApiDocumentAnswers                      = "application/json"
	routeGetProtectedResourceMetadataAnswers            = "application/json"
	routeCreateMediaTokenSends                          = "application/json"
	routeCreateMediaTokenAnswers                        = "application/json"
	routeGetCurrentUserAnswers                          = "application/json"
	routeGetStatusAnswers                               = "application/json"
	routeSubscribeToBusSends                            = "application/json"
	routeSubscribeToBusAnswers                          = "text/event-stream"
	routeEmitOnBusSends                                 = "application/json"
	routeEmitOnBusAnswers                               = "application/json"
	routeUploadResourceSends                            = "multipart/form-data"
	routeUploadResourceAnswers                          = "application/json"
	routeGetResourceRepresentationAnswers               = "*/*"
	routeGetResourceJsonLdAnswers                       = "application/ld+json"
	routeGetResourceAnnotationsAnswers                  = "application/json"
	routeGetResourceAnchoredTextAnswers                 = "application/json"
	routeGetResourceRepresentationWithMediaTokenAnswers = "*/*"
)

// Each header the gateway's operations name, asked or answered.
const (
	HeaderCacheControl    = "Cache-Control"
	HeaderIdempotencyKey  = "Idempotency-Key"
	HeaderLink            = "Link"
	HeaderRetryAfter      = "Retry-After"
	HeaderWWWAuthenticate = "WWW-Authenticate"
)

const (
	// MediaTokenQuery is the query parameter a mediaToken credential is sent in.
	MediaTokenQuery = "token"
)

// uploadField is a member of an upload (ResourceUpload), and whether every
// upload sends it.
type uploadField struct {
	name     string
	required bool
}

// The name each member of an upload is sent under.
const (
	uploadFieldName               = "name"
	uploadFieldFile               = "file"
	uploadFieldFormat             = "format"
	uploadFieldStorageUri         = "storageUri"
	uploadFieldLanguage           = "language"
	uploadFieldEntityTypes        = "entityTypes"
	uploadFieldSourceAnnotationId = "sourceAnnotationId"
	uploadFieldSourceResourceId   = "sourceResourceId"
	uploadFieldGenerationPrompt   = "generationPrompt"
	uploadFieldGenerator          = "generator"
	uploadFieldJobId              = "jobId"
	uploadFieldIsDraft            = "isDraft"
	uploadFieldCloneToken         = "cloneToken"
	uploadFieldArchiveOriginal    = "archiveOriginal"
)

// uploadFields is every member of an upload, in the schema's order.
var uploadFields = []uploadField{
	{name: uploadFieldName, required: true},
	{name: uploadFieldFile, required: true},
	{name: uploadFieldFormat, required: true},
	{name: uploadFieldStorageUri, required: true},
	{name: uploadFieldLanguage, required: false},
	{name: uploadFieldEntityTypes, required: false},
	{name: uploadFieldSourceAnnotationId, required: false},
	{name: uploadFieldSourceResourceId, required: false},
	{name: uploadFieldGenerationPrompt, required: false},
	{name: uploadFieldGenerator, required: false},
	{name: uploadFieldJobId, required: false},
	{name: uploadFieldIsDraft, required: false},
	{name: uploadFieldCloneToken, required: false},
	{name: uploadFieldArchiveOriginal, required: false},
}

// The name each member of a bus frame (BusFrame) is written under.
const (
	busFrameChannel       = "channel"
	busFrameCorrelationId = "correlationId"
	busFramePayload       = "payload"
	busFrameScope         = "scope"
)

// clientSecretForm is the form a service account posts with a client secret.
func clientSecretForm(clientID string, clientSecret string) url.Values {
	return url.Values{"grant_type": {"client_credentials"}, "client_id": {clientID}, "client_secret": {clientSecret}}
}
