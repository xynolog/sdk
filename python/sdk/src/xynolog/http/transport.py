"""A knowledge base's bus over its gateway's HTTP transport (`protocol/contract/TRANSPORT-HTTP.md`), as a `xynolog.transport.Transport`.

One stream, `POST /bus/subscribe`, naming the client's global channels and an
entry per resource scope it holds; and `POST /bus/emit` for what it sends. The
stream is `xynolog.http.stream`'s. The gateway's own operations ride plain
request and response, and so does content (`HttpTransport.content`).

What crosses the wire is told to OpenTelemetry as the telemetry table says:
each emit is counted and sent in a span whose trace travels with it, and each
frame's arrival is marked in the trace the frame was sent under.
"""

import asyncio
import uuid
from collections.abc import Collection, Mapping, Sequence
from types import TracebackType
from typing import Final, Self, final, override

import httpx
from pydantic import JsonValue

from xynolog import telemetry
from xynolog._bus_log import bus_log
from xynolog._kept_for_first_reader import KeptForFirstReader
from xynolog.channels import RESOURCE_SCOPED_CHANNELS
from xynolog.errors import TransportError, XynologError
from xynolog.events import Events
from xynolog.http._withheld import why_unanswered
from xynolog.http.content import HttpContentTransport
from xynolog.http.exchange import Exchange, TokenRefresher, refusal
from xynolog.http.gateway_http import (
    CREATE_MEDIA_TOKEN,
    CREATE_MEDIA_TOKEN_SENDS,
    EMIT_ON_BUS,
    EMIT_ON_BUS_SENDS,
    GET_CURRENT_USER,
    GET_HEALTH,
    GET_PROTECTED_RESOURCE_METADATA,
    GET_STATUS,
    IDEMPOTENCY_KEY,
    RETRY_AFTER,
)
from xynolog.http.stream import Bookmarks, Stream
from xynolog.identifiers import ResourceId
from xynolog.required import read_as
from xynolog.retry import BOOT, RetryFacts, retry_after_ms, retry_with_backoff
from xynolog.timing import EMIT_TIMEOUT_MS, TransportTiming
from xynolog.transport import (
    ConnectionState,
    ContentTransport,
    Frame,
    FrameHub,
    FrameSink,
    GatewayOperations,
    PendingReply,
    ReplyRouter,
    ResourceHold,
    Transport,
    unsubscribed,
)
from xynolog.types import (
    BusEmitAccepted,
    BusEmitRequest,
    Fault,
    FrameRefusal,
    HealthResponse,
    MediaTokenRequest,
    MediaTokenResponse,
    ProtectedResourceMetadata,
    StatusResponse,
    UserResponse,
)
from xynolog.watched import Watched

__all__ = ["HttpTransport"]


def _worth_another_emit(error: XynologError) -> bool:
    """Whether an emit that failed this way is made again inside its budget: nothing answered, or the gateway said "not now".

    A refused credential is not, whatever its status: it is renewed, never retried.
    """
    return error.code != "unauthorized" and (error.status is None or BOOT.retryable(RetryFacts(status=error.status, method="POST")))


@final
class HttpTransport(Transport, GatewayOperations):
    """A transport to one gateway. Held with `async with`: its stream opens inside, once there is a token, and ends on the way out.

    `token` is the token every request carries: the present one, and each one
    after it. With none the transport sends nothing and waits for one.
    `refresher` is asked for another when the gateway refuses the one it has,
    and is told the token refused; with none, a refused token is waited out
    until `token` changes.
    `channels` are the global channels its stream names, and it assumes
    none of its own: a full client's are `xynolog.channels.BRIDGED_CHANNELS`,
    and a process that awaits only some operations names their reply
    channels and no others. With `bookmarks`, each scope's stream
    begins where they say the client's last life left it; with none, at the
    present. `http` is the HTTP client every request is made with, which its
    caller built and closes: the certificates it trusts and the proxy it goes
    through are that client's. With none, the transport makes its own, and
    closes it once it is closed.
    """

    def __init__(
        self,
        base_url: str,
        *,
        token: Watched[str | None],
        refresher: TokenRefresher | None = None,
        channels: Sequence[str],
        timing: TransportTiming | None = None,
        bookmarks: Bookmarks | None = None,
        http: httpx.AsyncClient | None = None,
    ) -> None:
        self._base_url: Final = base_url.rstrip("/")
        self._token: Final = token
        self._global: Final = tuple(channels)
        self._timing: Final = TransportTiming() if timing is None else timing
        # This client's address for correlated replies: one per transport, not
        # per connection, so both streams of a handoff present the same one.
        self._client_id: Final = str(uuid.uuid4())
        self._hub: Final = FrameHub()
        self._router: Final = ReplyRouter()
        self._failures: Final = KeptForFirstReader[XynologError]()
        # Its own reads no environment variable: no proxy and no certificate file it was not given.
        self._http: Final = httpx.AsyncClient(timeout=None, trust_env=False) if http is None else http
        self._owns_http: Final = http is None
        """Whether the client is the transport's own, which it closes. One its caller gave it, its caller closes."""
        self._stream: Final = Stream(
            base_url=self._base_url,
            http=self._http,
            token=token,
            refresher=refresher,
            client_id=self._client_id,
            channels=self._global,
            timing=self._timing,
            hub=self._hub,
            router=self._router,
            failures=self._failures,
            bookmarks=bookmarks,
        )
        self._closing: Final = asyncio.Event()
        self._exchange: Final = Exchange(
            base_url=self._base_url,
            http=self._http,
            token=token,
            refresher=refresher,
            failures=self._failures,
            deadline_ms=self._timing.http_request_timeout_ms,
            closing=self._closing,
        )
        self._content: Final = HttpContentTransport(self._exchange)
        self._holds: Final[dict[ResourceId, int]] = {}
        """How many holds each resource's scope has."""
        self._running: asyncio.Task[None] | None = None
        self._closed: Final = asyncio.Event()
        self._emitting = 0
        self._quiet: Final = asyncio.Event()
        """Set while no emit of this transport is under way."""
        self._quiet.set()

    async def __aenter__(self) -> Self:
        if self._running is not None or self._closing.is_set():
            raise RuntimeError("a transport is opened once")
        self._running = asyncio.create_task(self._run())
        return self

    async def __aexit__(self, kind: type[BaseException] | None, error: BaseException | None, trace: TracebackType | None) -> None:
        await self.close()

    async def _run(self) -> None:
        """The transport's life: its stream, until it is closed; then the emits under way, each to its end."""
        try:
            await self._stream.run()
            await self._quiet.wait()
        finally:
            # A failure is reported for as long as an emit can fail: to the end.
            self._failures.close()
            try:
                # Whatever else is on the wire ends here, as a request that got no answer.
                self._closing.set()
                await self._exchange.ended()
                if self._owns_http:
                    await self._http.aclose()
            finally:
                self._closed.set()

    @property
    @override
    def base_url(self) -> str:
        return self._base_url

    @property
    @override
    def state(self) -> Watched[ConnectionState]:
        return self._stream.state

    @property
    def content(self) -> ContentTransport:
        """Bytes, a resource's description and its anchored text, from the same gateway."""
        return self._content

    @override
    def failures(self) -> Events[XynologError]:
        return self._failures.listen()

    @override
    def is_subscribed(self, channel: str) -> bool:
        return channel in self._global

    @override
    def frames(self, channel: str) -> Events[Frame | FrameRefusal]:
        # A channel this stream can never carry would be a reader that is
        # never given anything, which reads as a quiet system: refused at the
        # call. A resource-scoped channel passes with no scope held yet, since
        # frames flow the moment one is.
        if not self.is_subscribed(channel) and channel not in RESOURCE_SCOPED_CHANNELS:
            raise unsubscribed(channel)
        return self._hub.frames(channel)

    @override
    def track_reply(self, correlation_id: str, reply_channels: Collection[str]) -> PendingReply:
        return self._router.track(correlation_id, reply_channels)

    @override
    def bridge_into(self, bus: FrameSink) -> None:
        self._hub.bridge(bus)

    def attach_bookmarks(self, bookmarks: Bookmarks) -> None:
        """Keep each scope's place in `bookmarks` from now on, as one given them when it was made would.

        A scope the stream holds a place for keeps it; any other begins where
        they say the next time the stream asks for it. A session made before
        it knew who its person is gives it this once the gateway says.
        """
        self._stream.attach_bookmarks(bookmarks)

    @override
    def subscribe_to_resource(self, resource_id: ResourceId) -> ResourceHold:
        held = self._holds.get(resource_id, 0)
        self._holds[resource_id] = held + 1
        if held == 0:
            self._stream.take_scope(resource_id)

        def release() -> None:
            remaining = self._holds[resource_id] - 1
            if remaining > 0:
                self._holds[resource_id] = remaining
                return
            del self._holds[resource_id]
            self._stream.let_go_of_scope(resource_id)

        return ResourceHold(release)

    @override
    async def emit(
        self,
        channel: str,
        payload: Mapping[str, JsonValue],
        *,
        scope: ResourceId | None = None,
        correlation_id: str | None = None,
    ) -> int | None:
        if self._running is None:
            raise RuntimeError("the transport is not open: hold it with `async with`")
        bus_log("EMIT", channel, payload, scope=scope, correlation_id=correlation_id)
        body = BusEmitRequest(
            channel=channel,
            payload=dict(payload),
            scope=scope,
            client_id=self._client_id,
            correlation_id=correlation_id,
        ).model_dump_json(exclude_none=True)
        self._emitting += 1
        self._quiet.clear()
        try:
            with telemetry.emitting(channel, scope):
                return await self._emitted(body)
        except TransportError as error:
            # A failed emit is reported where every failure is, as its caller hears it.
            self._failures.deliver(error)
            raise
        finally:
            self._emitting -= 1
            if self._emitting == 0:
                self._quiet.set()

    async def _emitted(self, body: str) -> int | None:
        """An emit, made inside its budget with the token there is now.

        One whose credential is refused is renewed outside the budget: the
        refresher is asked once, and the emit is made again at once with the
        token it gives. Refused again, it fails. Its key is made once, and
        every attempt carries it, so the gateway knows each as the same emit.
        """
        key = str(uuid.uuid4())
        token = self._token.value
        try:
            return await self._within_budget(body, key, token)
        except TransportError as refused:
            if refused.code != "unauthorized" or self._closing.is_set():
                raise
            renewed = await self._exchange.renewal(token)
            if renewed is None:
                raise
        return await self._within_budget(body, key, renewed)

    async def _within_budget(self, body: str, key: str, token: str | None) -> int | None:
        """An emit's attempts, each with `key` and `token`, until one is accepted or `emit_retry` is spent."""
        return await retry_with_backoff(
            self._timing.emit_retry,
            lambda: self._emit_once(body, key, token),
            retryable=_worth_another_emit,
            give_up=self._closing,
        )

    async def _emit_once(self, body: str, key: str, token: str | None) -> int | None:
        """One attempt of an emit: `POST /bus/emit` with its `key` and `token`, answered within `EMIT_TIMEOUT_MS`."""
        if self._closing.is_set():
            raise TransportError("error", f"{EMIT_ON_BUS.path} was not sent: the transport is closed")
        try:
            async with asyncio.timeout(EMIT_TIMEOUT_MS / 1000):
                response = await self._http.request(
                    EMIT_ON_BUS.method,
                    f"{self._base_url}{EMIT_ON_BUS.path}",
                    content=body,
                    headers={
                        **telemetry.trace_headers(),
                        "Authorization": f"Bearer {token or ''}",
                        "Content-Type": EMIT_ON_BUS_SENDS,
                        IDEMPOTENCY_KEY: key,
                    },
                )
        except TimeoutError:
            raise TransportError.without_response(f"{EMIT_ON_BUS.path} got no answer within {EMIT_TIMEOUT_MS // 1000}s") from None
        except httpx.HTTPError as error:
            raise TransportError.without_response(f"{EMIT_ON_BUS.path} got no answer: {why_unanswered(error)}") from None
        if not response.is_success:
            status = response.status_code
            detail = response.text[:500]
            raise refusal(
                f"{EMIT_ON_BUS.path} {status}: {detail}" if detail else f"{EMIT_ON_BUS.path} {status}",
                status,
                response.content,
                retry_after_ms(response.headers.get(RETRY_AFTER)),
            )
        # No count is reported as no count, never as a zero: an absent
        # `subscribers` is the gateway saying it could not count, and a body
        # that is no BusEmitAccepted, as the table holds it, says nothing at all.
        accepted = read_as(BusEmitAccepted, response.content, BusEmitAccepted.model_validate)
        return None if isinstance(accepted, Fault) else accepted.subscribers

    @override
    async def get_current_user(self) -> UserResponse:
        return await self._exchange.answer(UserResponse, GET_CURRENT_USER.method, GET_CURRENT_USER.path)

    @override
    async def get_media_token(self, resource_id: ResourceId) -> MediaTokenResponse:
        return await self._exchange.answer(
            MediaTokenResponse,
            CREATE_MEDIA_TOKEN.method,
            CREATE_MEDIA_TOKEN.path,
            headers={"Content-Type": CREATE_MEDIA_TOKEN_SENDS},
            content=MediaTokenRequest(resource_id=resource_id).model_dump_json().encode(),
        )

    @override
    async def get_protected_resource_metadata(self) -> ProtectedResourceMetadata:
        return await self._exchange.answer(
            ProtectedResourceMetadata, GET_PROTECTED_RESOURCE_METADATA.method, GET_PROTECTED_RESOURCE_METADATA.path, authenticated=False
        )

    @override
    async def health_check(self) -> HealthResponse:
        return await self._exchange.answer(HealthResponse, GET_HEALTH.method, GET_HEALTH.path)

    @override
    async def get_status(self) -> StatusResponse:
        return await self._exchange.answer(StatusResponse, GET_STATUS.method, GET_STATUS.path)

    @override
    async def close(self) -> None:
        if not self._closing.is_set():
            self._closing.set()
            self._stream.stop()
            if self._running is None:
                # Never opened: its stream's task runs only to end.
                self._running = asyncio.create_task(self._run())
        await self._closed.wait()
        if self._running is not None:
            # Whatever ended the stream's task that was not its closing is raised here.
            await self._running
