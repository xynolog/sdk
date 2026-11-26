"""Bytes over the gateway's HTTP transport, as a `xynolog.transport.ContentTransport`.

An upload (`POST /resources`), a resource's bytes whole or as a stream
(`GET /resources/{id}`), its description as linked data
(`GET /resources/{id}/jsonld`), its annotations
(`GET /resources/{id}/annotations`), and its anchored text
(`GET /resources/{id}/anchored-text`). Bytes never ride the bus.

It makes its requests as the bus transport makes its own, so one here is
refused, tried again and reported as any other; and each is made in a span of
the telemetry table (`content.put`, `content.get`, `content.get_graph`,
`content.get_annotations`, `content.get_anchored_text`).
"""

import asyncio
import uuid
from collections.abc import AsyncGenerator, AsyncIterator, Callable
from typing import Final, Self, final, override

import httpx
from pydantic import TypeAdapter

from xynolog import telemetry
from xynolog._bus_log import bus_log
from xynolog.errors import TransportError
from xynolog.http._withheld import why_unanswered
from xynolog.http.exchange import Exchange
from xynolog.http.gateway_http import (
    GET_RESOURCE_ANCHORED_TEXT,
    GET_RESOURCE_ANNOTATIONS,
    GET_RESOURCE_JSON_LD,
    GET_RESOURCE_REPRESENTATION,
    IDEMPOTENCY_KEY,
    UPLOAD_RESOURCE,
    UPLOAD_RESOURCE_SENDS,
    GatewayRoute,
)
from xynolog.identifiers import ResourceId
from xynolog.transport import ContentStream, ContentTransport, Upload
from xynolog.types import (
    Agent,
    AnchoredTextAnswer,
    CreateResourceResponse,
    GetAnnotationsResponse,
    GetResourceResponse,
    OneOrMoreAgents,
    PutBinaryRequest,
    ResourceRepresentation,
    ResourceUpload,
    UploadProgress,
    UploadProgressProgress,
    UploadProgressStarted,
)

__all__ = ["HttpContentTransport", "form_of"]

# How much of an upload's body is handed to the connection at a time: the grain its progress is reported in.
_UPLOAD_PIECE_BYTES: Final = 64 * 1024


_AGENT: Final = TypeAdapter[Agent](Agent)
_AGENTS: Final = TypeAdapter[list[Agent]](list[Agent])
_NAMES: Final = TypeAdapter[list[str]](list[str])
_ANCHORED_TEXT: Final = TypeAdapter[AnchoredTextAnswer](AnchoredTextAnswer)


def _flag(value: bool | None) -> str | None:
    return None if value is None else "true" if value else "false"


def _generated_by(generator: OneOrMoreAgents | None) -> str | None:
    if generator is None:
        return None
    if isinstance(generator, list):
        return _AGENTS.dump_json(generator, by_alias=True, exclude_unset=True).decode()
    return _AGENT.dump_json(generator, by_alias=True, exclude_unset=True).decode()


def form_of(request: PutBinaryRequest) -> ResourceUpload:
    """An upload as its form carries it: every field text but the bytes. A field with nothing to say is left out."""
    return ResourceUpload(
        name=request.name,
        file=request.file,
        format=request.format,
        storage_uri=request.storage_uri,
        language=request.language or None,
        entity_types=_NAMES.dump_json(request.entity_types).decode() if request.entity_types else None,
        source_annotation_id=request.source_annotation_id,
        source_resource_id=request.source_resource_id,
        generation_prompt=request.generation_prompt or None,
        generator=_generated_by(request.generator),
        job_id=request.job_id,
        is_draft=_flag(request.is_draft),
        clone_token=request.clone_token or None,
        archive_original=_flag(request.archive_original),
    )


def _quoted(text: str) -> str:
    """`text` as a part's header states it: what would end the value, or the line, written as `%XX`."""
    return text.replace('"', "%22").replace("\r", "%0D").replace("\n", "%0A")


@final
class _Form:
    """An upload's body, as `UPLOAD_RESOURCE` sends it: each field under its own name, the bytes as the part that holds them.

    The fields every upload sends come before the bytes, so whatever reads the
    form knows what the bytes are before it meets them; the others follow.
    """

    def __init__(self, request: PutBinaryRequest) -> None:
        self.boundary: Final = f"xynolog-{uuid.uuid4().hex}"
        form = form_of(request)
        before: list[str] = []
        after: list[str] = []
        named: str | None = None
        for name, field in ResourceUpload.model_fields.items():
            value: object = getattr(form, name)
            member = _quoted(field.alias or name)
            if isinstance(value, bytes):
                named = f'name="{member}"; filename="{_quoted(form.name)}"'
                continue
            if value is None:
                continue
            if not isinstance(value, str):
                raise TypeError(f"the upload form's {name} is not text")
            part = f'--{self.boundary}\r\nContent-Disposition: form-data; name="{member}"\r\n\r\n{value}\r\n'
            (before if field.is_required() else after).append(part)
        if named is None:
            raise TypeError("the upload form has no member that holds its bytes")
        before.append(f"--{self.boundary}\r\nContent-Disposition: form-data; {named}\r\nContent-Type: {form.format}\r\n\r\n")
        # The parts before the bytes, the bytes, and what follows them: the bytes are not copied to make the body.
        self._parts: Final = ("".join(before).encode(), form.file, ("\r\n" + "".join(after) + f"--{self.boundary}--\r\n").encode())
        self.size: Final = sum(len(part) for part in self._parts)

    def pieces(self) -> list[memoryview]:
        """The body, a piece at a time."""
        return [
            memoryview(part)[start : start + _UPLOAD_PIECE_BYTES]
            for part in self._parts
            for start in range(0, len(part), _UPLOAD_PIECE_BYTES)
        ]


@final
class _Progress:
    """How much of an upload has been reported sent, over every sending of it.

    Made, it reports the upload's size, before any sending. A sending that
    repeats an earlier one, as the second attempt of a refused upload does,
    reports only what goes past it: progress never goes back.
    """

    def __init__(self, total: int, report: Callable[[UploadProgress], None]) -> None:
        self._total = total
        self._report = report
        self._reported = 0
        report(UploadProgressStarted(phase="started", total_bytes=total))

    def sent(self, so_far: int) -> None:
        if so_far > self._reported:
            self._reported = so_far
            self._report(UploadProgressProgress(phase="progress", bytes_uploaded=so_far, total_bytes=self._total))


@final
class _Sending:
    """An upload's body as it is sent once: each piece reported as it is handed to the connection."""

    def __init__(self, form: _Form, progress: _Progress) -> None:
        self._pieces = iter(form.pieces())
        self._sent = 0
        self._progress = progress

    def __aiter__(self) -> Self:
        return self

    async def __anext__(self) -> bytes:
        piece = next(self._pieces, None)
        if piece is None:
            raise StopAsyncIteration
        self._sent += len(piece)
        self._progress.sent(self._sent)
        return bytes(piece)


def _path_of(route: GatewayRoute, resource_id: ResourceId) -> str:
    """Where `route` reads a resource.

    Its id is one segment of the path as it is: the rule an id is held to
    admits nothing a path reads as its own.
    """
    return route.path.replace("{id}", str(resource_id), 1)


def _content_type(response: httpx.Response) -> str:
    stated: str | None = response.headers.get("content-type")
    return stated or "application/octet-stream"


def _interrupted(resource_id: ResourceId, error: httpx.HTTPError) -> TransportError:
    """A read whose bytes stopped coming."""
    read = f"{GET_RESOURCE_REPRESENTATION.method} {_path_of(GET_RESOURCE_REPRESENTATION, resource_id)}"
    return TransportError.without_response(f"{read} ended before its bytes did: {why_unanswered(error)}")


@final
class HttpContentTransport(ContentTransport):
    """Content over the gateway an `HttpTransport` speaks to. It is that transport's `content`."""

    def __init__(self, exchange: Exchange) -> None:
        self._exchange = exchange

    @override
    def put_binary(self, request: PutBinaryRequest) -> Upload:
        def start(report: Callable[[UploadProgress], None]) -> asyncio.Task[CreateResourceResponse]:
            return self._exchange.run(self._put(request, report))

        return Upload(start)

    async def _put(self, request: PutBinaryRequest, report: Callable[[UploadProgress], None]) -> CreateResourceResponse:
        form = _Form(request)
        progress = _Progress(form.size, report)
        bus_log(
            "PUT",
            "content",
            {"name": request.name, "format": request.format, "storageUri": request.storage_uri, "sizeBytes": len(request.file)},
        )
        with telemetry.putting(request.format, len(request.file)):
            # No deadline: how long an upload takes is how large the resource is.
            # Its key is made once: every attempt carries it, so the gateway knows each as the same upload,
            # and one that got no answer, or a status that promises recovery, is sent again as a read is.
            return await self._exchange.answer(
                CreateResourceResponse,
                UPLOAD_RESOURCE.method,
                UPLOAD_RESOURCE.path,
                headers={
                    "Content-Type": f"{UPLOAD_RESOURCE_SENDS}; boundary={form.boundary}",
                    "Content-Length": str(form.size),
                    IDEMPOTENCY_KEY: str(uuid.uuid4()),
                },
                content=lambda: _Sending(form, progress),
                at_length=True,
            )

    @override
    async def get_binary(self, resource_id: ResourceId) -> ResourceRepresentation:
        bus_log("GET", "content", {"resourceId": resource_id})
        with telemetry.getting(resource_id, stream=False):
            # The deadline is on the bytes beginning to arrive: how long they take after that is how many there are.
            response = await self._exchange.begin(GET_RESOURCE_REPRESENTATION.method, _path_of(GET_RESOURCE_REPRESENTATION, resource_id))
            try:
                data = await response.aread()
            except httpx.HTTPError as error:
                raise self._exchange.failed(_interrupted(resource_id, error)) from None
            finally:
                await response.aclose()
            return ResourceRepresentation(data=data, content_type=_content_type(response))

    @override
    async def get_binary_stream(self, resource_id: ResourceId) -> ContentStream:
        bus_log("GET", "content", {"resourceId": resource_id, "stream": True})
        with telemetry.getting(resource_id, stream=True):
            response = await self._exchange.begin(GET_RESOURCE_REPRESENTATION.method, _path_of(GET_RESOURCE_REPRESENTATION, resource_id))
        return ContentStream(_content_type(response), self._arriving(resource_id, response))

    async def _arriving(self, resource_id: ResourceId, response: httpx.Response) -> AsyncGenerator[bytes]:
        pieces: AsyncIterator[bytes] = response.aiter_bytes()
        try:
            async for piece in pieces:
                yield piece
        except httpx.HTTPError as error:
            raise self._exchange.failed(_interrupted(resource_id, error)) from None
        finally:
            # A read left early is ended here, by the one who left it.
            if isinstance(pieces, AsyncGenerator):
                await pieces.aclose()
            await response.aclose()

    @override
    async def get_resource_graph(self, resource_id: ResourceId) -> GetResourceResponse:
        bus_log("GET", "content", {"resourceId": resource_id, "graph": True})
        with telemetry.getting_graph(resource_id):
            return await self._exchange.answer(
                GetResourceResponse, GET_RESOURCE_JSON_LD.method, _path_of(GET_RESOURCE_JSON_LD, resource_id)
            )

    @override
    async def get_annotations(self, resource_id: ResourceId) -> GetAnnotationsResponse:
        bus_log("GET", "content", {"resourceId": resource_id, "annotations": True})
        with telemetry.getting_annotations(resource_id):
            return await self._exchange.answer(
                GetAnnotationsResponse, GET_RESOURCE_ANNOTATIONS.method, _path_of(GET_RESOURCE_ANNOTATIONS, resource_id)
            )

    @override
    async def get_anchored_text(self, resource_id: ResourceId) -> AnchoredTextAnswer:
        bus_log("GET", "content", {"resourceId": resource_id, "anchoredText": True})
        with telemetry.getting_anchored_text(resource_id):
            return await self._exchange.answer_one_of(
                _ANCHORED_TEXT,
                AnchoredTextAnswer,
                GET_RESOURCE_ANCHORED_TEXT.method,
                _path_of(GET_RESOURCE_ANCHORED_TEXT, resource_id),
            )
