"""A client of one knowledge base: its eleven namespaces over a transport, the bytes that never ride the bus, and the gateway's own answers.

A client owns a bus of its own (`bus`). Its transport delivers into that bus
every frame it receives, each once the client's refresher has taken it, and
what the client's own parts say to each other (a viewer's signals) goes
through it and never reaches the wire. The namespaces
are attributes: `client.browse`, `client.mark`, and so on, with `yield_` for
the one whose name Python keeps for itself.

A client keeps its queries true: what `browse`, `gather` and `match` answer
as live queries comes from its cache, and each event its transport delivers
refreshes what the cache holds (`xynolog.cached`). With a `persistence`, the
small queries are kept there, and the next client of the same knowledge base
shows them at once.

A client is held with `async with`, and inside it listens for what keeps
its queries true. On the way out its live queries end, its followed jobs end,
every reader of its own bus is told there is no more, and the tasks it
started have ended. It does not open or close its transport: whoever opened
that closes it, after the client.

    async with HttpTransport(origin, token=token, channels=BRIDGED_CHANNELS) as transport:
        async with XynologClient(transport, transport.content, transport) as client:
            resource = await client.browse.resource(resource_id).fresh()
"""

from collections.abc import Callable
from types import TracebackType
from typing import Final, Self, final, override

from xynolog.bus import Bus
from xynolog.event_bus import EventBus
from xynolog.namespaces.auth import AuthNamespace
from xynolog.namespaces.beckon import BeckonNamespace
from xynolog.namespaces.bind import BindNamespace
from xynolog.namespaces.browse import BrowseNamespace
from xynolog.namespaces.frame import FrameNamespace
from xynolog.namespaces.gather import GatherNamespace
from xynolog.namespaces.job import JobNamespace
from xynolog.namespaces.links import Links
from xynolog.namespaces.live import CachePersistence, Live
from xynolog.namespaces.mark import MarkNamespace
from xynolog.namespaces.match import MatchNamespace
from xynolog.namespaces.refresher import Refresher
from xynolog.namespaces.system import SystemNamespace
from xynolog.namespaces.yield_ import YieldNamespace
from xynolog.resume import seal_coupled_places
from xynolog.timing import ClientTiming
from xynolog.transport import ContentTransport, Frame, FrameRefusal, FrameSink, GatewayOperations, Transport

__all__ = ["CachePersistence", "ClientTiming", "XynologClient"]


@final
class _Delivery(FrameSink):
    """Where a client's transport delivers: to its refresher, and then to its bus.

    The refresher has taken a frame by the time its delivery returns, so a
    stream that notes a frame's place after delivering it (`xynolog.resume`)
    notes it only once the refetch it asked for is in flight or owed.
    """

    def __init__(self, refresher: Refresher, bus: EventBus) -> None:
        self._refresher: Final = refresher
        self._bus: Final = bus

    @override
    def deliver(self, frame: Frame | FrameRefusal) -> None:
        self._refresher.take(frame)
        self._bus.deliver(frame)


@final
class XynologClient[T: Transport]:
    """See the module's documentation.

    `content` carries the bytes and `gateway` answers for itself; over HTTP
    the transport is all three. `transport` is kept as the kind of transport
    it is, for what the namespaces do not cover: a frame on a channel by name,
    a hold on a resource's scope.
    """

    def __init__(
        self,
        transport: T,
        content: ContentTransport,
        gateway: GatewayOperations,
        *,
        timing: ClientTiming | None = None,
        persistence: CachePersistence | None = None,
    ) -> None:
        kept = ClientTiming() if timing is None else timing
        self.transport: Final[T] = transport
        self.timing: Final = kept
        self.bus: Final = EventBus()
        """The client's own bus: every frame the transport delivered, and every signal the client's parts gave each other."""
        self.wire: Final = Bus(transport)
        """The bus over the transport, typed by channel: an emit, a channel's frames, a request."""
        self._links: Final = Links(
            transport=transport,
            wire=self.wire,
            own=self.bus,
            bus_request_timeout_ms=kept.bus_request_timeout_ms,
            job_silence_ms=kept.job_silence_ms,
            job_status_poll_ms=kept.job_status_poll_ms,
        )
        self._closed = False
        self._held = False
        self._live: Final = Live(self._links, content, persistence)
        self._refresher: Final = Refresher(self._links, self._live, invalidation_window_ms=kept.invalidation_window_ms)
        transport.bridge_into(_Delivery(self._refresher, self.bus))
        self._unwritten: Callable[[], bool] | None = None
        """Whether a write of what the client keeps, which the storage refused, is still owed: given by `attach_persistence`."""

        self.frame: Final = FrameNamespace(self._links)
        """The vocabulary: what kinds of things exist."""
        self.browse: Final = BrowseNamespace(self._links, content, self._live)
        """Reads, and this viewer's own signals."""
        self.mark: Final = MarkNamespace(self._links)
        """Annotations, a resource's own metadata, and the annotating of a resource delegated as a job."""
        self.bind: Final = BindNamespace(self._links)
        """Linking a reference to what it refers to."""
        self.gather: Final = GatherNamespace(self._links, self._live)
        """Assembling the context a model is given, and what refers to a resource."""
        self.match: Final = MatchNamespace(self._links, self._live)
        """Searching: for what a reference could refer to, and for resources by text."""
        self.yield_: Final = YieldNamespace(self._links, content)
        """Creating resources."""
        self.beckon: Final = BeckonNamespace(self._links)
        """Attention: driving the other participants' viewers."""
        self.job: Final = JobNamespace(self._links)
        """Jobs: their lifecycle, their status and their cancellation."""
        self.auth: Final = AuthNamespace(gateway)
        """The gateway's view of who is signed in."""
        self.system: Final = SystemNamespace(gateway)
        """What the knowledge base says about itself."""

    async def __aenter__(self) -> Self:
        if self._closed or self._held:
            raise RuntimeError("a client is held once")
        self._held = True
        self._refresher.start()
        self._live.kept_true()
        return self

    async def __aexit__(self, kind: type[BaseException] | None, error: BaseException | None, trace: TracebackType | None) -> None:
        await self.close()

    @property
    def persistence_settled(self) -> bool:
        """Whether everything the client keeps is at rest.

        No kept cache is fetching or owes a save, the refresher owes no
        refetch, and no write the storage refused is owed. What is kept of
        the stream's place is kept only then (`xynolog.resume`).
        """
        unwritten = self._unwritten is not None and self._unwritten()
        return self._live.persistence_settled and not self._refresher.owes_a_refetch and not unwritten

    def attach_persistence(self, persistence: CachePersistence, *, unwritten: Callable[[], bool]) -> None:
        """Keep what the client's queries hold where `persistence` says, from now on: what a client made with it would keep.

        What was kept there is shown for each key a query holds nothing for,
        and asked for anew the first time it is observed. A session made
        before it knew who its person is gives it this once the gateway says.
        `unwritten` says whether a write to `persistence`'s storage that the
        storage refused is still owed: one made later than the caches save,
        as a session's are, whose refusal no cache hears.
        """
        self._live.attach(persistence)
        self._unwritten = unwritten

    async def close(self) -> None:
        """End the client.

        The queries end first: every watcher's states end, a read asked for
        after is refused as `bus.closed`, and what was owed to storage is
        saved. Then its own bus ends, so every reader of it and every followed
        job does, and then the tasks it started: a read still waiting for its
        answer fails as `bus.closed`. Closing twice is closing once.

        Before anything is disposed, the places coupled to the client
        (`xynolog.resume.CoupledBookmarks.couple_to`) are told whether they may
        ride the saves the close makes: only when no kept cache is fetching
        and the refresher owes no refetch, since closing drops both.
        """
        self._closed = True
        seal_coupled_places(self, not self._refresher.owes_a_refetch and not self._live.fetching_what_it_keeps)
        self._refresher.dispose()
        self._live.dispose()
        self.bus.destroy()
        await self._links.close()
