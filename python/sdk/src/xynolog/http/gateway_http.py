# Generated from protocol/specs/src/openapi.json and its paths; do not edit.
# Regenerate: make generate (codegen/lib/gateway_http/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The gateway's HTTP surface: its operations, the media types each sends and
answers with, the headers they name, a bus frame's members, and the client
secret form.
"""

from dataclasses import dataclass
from typing import Final, final

__all__ = [
    "BUS_FRAME_CHANNEL",
    "BUS_FRAME_CORRELATION_ID",
    "BUS_FRAME_PAYLOAD",
    "BUS_FRAME_SCOPE",
    "CACHE_CONTROL",
    "CREATE_MEDIA_TOKEN",
    "CREATE_MEDIA_TOKEN_ANSWERS",
    "CREATE_MEDIA_TOKEN_SENDS",
    "EMIT_ON_BUS",
    "EMIT_ON_BUS_ANSWERS",
    "EMIT_ON_BUS_SENDS",
    "GET_CURRENT_USER",
    "GET_CURRENT_USER_ANSWERS",
    "GET_HEALTH",
    "GET_HEALTH_ANSWERS",
    "GET_HEALTH_AT_ROOT",
    "GET_HEALTH_AT_ROOT_ANSWERS",
    "GET_OPEN_API_DOCUMENT",
    "GET_OPEN_API_DOCUMENT_ANSWERS",
    "GET_PROTECTED_RESOURCE_METADATA",
    "GET_PROTECTED_RESOURCE_METADATA_ANSWERS",
    "GET_RESOURCE_ANCHORED_TEXT",
    "GET_RESOURCE_ANCHORED_TEXT_ANSWERS",
    "GET_RESOURCE_ANNOTATIONS",
    "GET_RESOURCE_ANNOTATIONS_ANSWERS",
    "GET_RESOURCE_JSON_LD",
    "GET_RESOURCE_JSON_LD_ANSWERS",
    "GET_RESOURCE_REPRESENTATION",
    "GET_RESOURCE_REPRESENTATION_ANSWERS",
    "GET_RESOURCE_REPRESENTATION_WITH_MEDIA_TOKEN",
    "GET_RESOURCE_REPRESENTATION_WITH_MEDIA_TOKEN_ANSWERS",
    "GET_STATUS",
    "GET_STATUS_ANSWERS",
    "GatewayRoute",
    "IDEMPOTENCY_KEY",
    "LINK",
    "RETRY_AFTER",
    "SUBSCRIBE_TO_BUS",
    "SUBSCRIBE_TO_BUS_ANSWERS",
    "SUBSCRIBE_TO_BUS_SENDS",
    "UPLOAD_RESOURCE",
    "UPLOAD_RESOURCE_ANSWERS",
    "UPLOAD_RESOURCE_SENDS",
    "WWW_AUTHENTICATE",
    "client_secret_form",
]


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class GatewayRoute:
    """An operation of the gateway: its method, and its path, a `{name}` for each
    parameter, which the caller fills."""

    method: str
    path: str


# `getHealth`.
GET_HEALTH: Final = GatewayRoute(method="GET", path="/api/health")

# `getHealthAtRoot`.
GET_HEALTH_AT_ROOT: Final = GatewayRoute(method="GET", path="/")

# `getOpenApiDocument`.
GET_OPEN_API_DOCUMENT: Final = GatewayRoute(method="GET", path="/api/openapi.json")

# `getProtectedResourceMetadata`.
GET_PROTECTED_RESOURCE_METADATA: Final = GatewayRoute(method="GET", path="/.well-known/oauth-protected-resource")

# `createMediaToken`.
CREATE_MEDIA_TOKEN: Final = GatewayRoute(method="POST", path="/api/tokens/media")

# `getCurrentUser`.
GET_CURRENT_USER: Final = GatewayRoute(method="GET", path="/api/users/me")

# `getStatus`.
GET_STATUS: Final = GatewayRoute(method="GET", path="/api/status")

# `subscribeToBus`.
SUBSCRIBE_TO_BUS: Final = GatewayRoute(method="POST", path="/bus/subscribe")

# `emitOnBus`.
EMIT_ON_BUS: Final = GatewayRoute(method="POST", path="/bus/emit")

# `uploadResource`.
UPLOAD_RESOURCE: Final = GatewayRoute(method="POST", path="/resources")

# `getResourceRepresentation`.
GET_RESOURCE_REPRESENTATION: Final = GatewayRoute(method="GET", path="/resources/{id}")

# `getResourceJsonLd`.
GET_RESOURCE_JSON_LD: Final = GatewayRoute(method="GET", path="/resources/{id}/jsonld")

# `getResourceAnnotations`.
GET_RESOURCE_ANNOTATIONS: Final = GatewayRoute(method="GET", path="/resources/{id}/annotations")

# `getResourceAnchoredText`.
GET_RESOURCE_ANCHORED_TEXT: Final = GatewayRoute(method="GET", path="/resources/{id}/anchored-text")

# `getResourceRepresentationWithMediaToken`.
GET_RESOURCE_REPRESENTATION_WITH_MEDIA_TOKEN: Final = GatewayRoute(method="GET", path="/api/resources/{id}")

GET_HEALTH_ANSWERS: Final = "application/json"
GET_HEALTH_AT_ROOT_ANSWERS: Final = "application/json"
GET_OPEN_API_DOCUMENT_ANSWERS: Final = "application/json"
GET_PROTECTED_RESOURCE_METADATA_ANSWERS: Final = "application/json"
CREATE_MEDIA_TOKEN_SENDS: Final = "application/json"
CREATE_MEDIA_TOKEN_ANSWERS: Final = "application/json"
GET_CURRENT_USER_ANSWERS: Final = "application/json"
GET_STATUS_ANSWERS: Final = "application/json"
SUBSCRIBE_TO_BUS_SENDS: Final = "application/json"
SUBSCRIBE_TO_BUS_ANSWERS: Final = "text/event-stream"
EMIT_ON_BUS_SENDS: Final = "application/json"
EMIT_ON_BUS_ANSWERS: Final = "application/json"
UPLOAD_RESOURCE_SENDS: Final = "multipart/form-data"
UPLOAD_RESOURCE_ANSWERS: Final = "application/json"
GET_RESOURCE_REPRESENTATION_ANSWERS: Final = "*/*"
GET_RESOURCE_JSON_LD_ANSWERS: Final = "application/ld+json"
GET_RESOURCE_ANNOTATIONS_ANSWERS: Final = "application/json"
GET_RESOURCE_ANCHORED_TEXT_ANSWERS: Final = "application/json"
GET_RESOURCE_REPRESENTATION_WITH_MEDIA_TOKEN_ANSWERS: Final = "*/*"

CACHE_CONTROL: Final = "Cache-Control"
IDEMPOTENCY_KEY: Final = "Idempotency-Key"
LINK: Final = "Link"
RETRY_AFTER: Final = "Retry-After"
WWW_AUTHENTICATE: Final = "WWW-Authenticate"

BUS_FRAME_CHANNEL: Final = "channel"
BUS_FRAME_CORRELATION_ID: Final = "correlationId"
BUS_FRAME_PAYLOAD: Final = "payload"
BUS_FRAME_SCOPE: Final = "scope"


def client_secret_form(client_id: str, client_secret: str) -> list[tuple[str, str]]:
    """The form a service account posts with a client secret, each member by its name, in the schema's order."""
    return [
        ("grant_type", "client_credentials"),
        ("client_id", client_id),
        ("client_secret", client_secret),
    ]
