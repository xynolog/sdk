"""A real client and a real session for tests. Every namespace, cache and deadline is the client's; only what it speaks through is a double.

A test scripts the doubles and observes through the client. What a test does
not give is a double that refuses: a request nobody scripted an answer for
fails naming its operation, a read of content nobody stored fails naming the
resource, and an operation of the gateway nobody scripted fails naming it.
"""

from dataclasses import dataclass
from typing import ClassVar, TypedDict, Unpack, final

from xynolog._option_defaults import TESTING_CREATE_TEST_SESSION_KB
from xynolog.channels import BRIDGED_CHANNELS
from xynolog.client import CachePersistence, XynologClient
from xynolog.session import MemorySignIn, SignInKept, XynologSession
from xynolog.testing.content import InMemoryContent
from xynolog.testing.gateway import StubGateway
from xynolog.testing.transport import FaultyTransport
from xynolog.timing import ClientTiming
from xynolog.types import KbTarget
from xynolog.watched import Variable

__all__ = ["TestClient", "TestSession", "TestSessionOptions", "create_test_client", "create_test_session"]


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class TestClient:
    """A client, and the doubles it speaks through."""

    # A name a test runner would otherwise take for a class of tests.
    __test__: ClassVar[bool] = False

    client: XynologClient[FaultyTransport]
    transport: FaultyTransport
    content: InMemoryContent
    gateway: StubGateway


def create_test_client(
    *,
    transport: FaultyTransport | None = None,
    content: InMemoryContent | None = None,
    gateway: StubGateway | None = None,
    timing: ClientTiming | None = None,
    persistence: CachePersistence | None = None,
) -> TestClient:
    """A real `XynologClient` over a `FaultyTransport`, an `InMemoryContent` and a `StubGateway`.

    Each double is the one given, as the test scripted it; absent, one that
    nothing is scripted to answer and that holds nothing, the transport's
    stream naming a full client's channels, `BRIDGED_CHANNELS`. `timing` and
    `persistence` are the client's own. The client is held with `async with`
    as any other is, and whoever made the transport closes it.
    """
    over = FaultyTransport(channels=BRIDGED_CHANNELS) if transport is None else transport
    holding = InMemoryContent() if content is None else content
    answering = StubGateway() if gateway is None else gateway
    client = XynologClient(over, holding, answering, timing=timing, persistence=persistence)
    return TestClient(client=client, transport=over, content=holding, gateway=answering)


class TestSessionOptions(TypedDict, total=False):
    """What a test session is built over: `create_test_session`'s keyword arguments. What a test leaves out is made."""

    client: TestClient
    """The test client the session is over. Left out, `create_test_client()`'s."""
    kb: KbTarget
    """The knowledge base the session is with. Left out, `TESTING_CREATE_TEST_SESSION_KB`."""
    kept: SignInKept
    """Where the session's sign-in is kept: a sign-in kept there is the session's at its start.

    Left out, a `MemorySignIn` that holds none.
    """


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class TestSession:
    """A session, and what it was built over."""

    # A name a test runner would otherwise take for a class of tests.
    __test__: ClassVar[bool] = False

    session: XynologSession[FaultyTransport]
    client: XynologClient[FaultyTransport]
    transport: FaultyTransport
    content: InMemoryContent
    gateway: StubGateway
    kept: SignInKept
    """Where the session's sign-in is kept."""
    token: Variable[str | None]
    """The token the session holds. A test that needs a signed-in session sets one."""


def create_test_session(**options: Unpack[TestSessionOptions]) -> TestSession:
    """A real `XynologSession` over a test client.

    It renews nothing and asks nobody who it is, so, held with `async with`, it
    is ready as soon as it has read where its sign-in is kept, and holds a
    token only if one was kept there. It only uses its client: the caller
    closes the client first and then ends the session, and whoever made the
    transport closes it.
    """
    given = options.get("client")
    made = create_test_client() if given is None else given
    kb = options.get("kb")
    kept = options.get("kept")
    held = MemorySignIn() if kept is None else kept
    token = Variable[str | None](None)
    session = XynologSession(kb=TESTING_CREATE_TEST_SESSION_KB if kb is None else kb, client=made.client, token=token, kept=held)
    return TestSession(
        session=session, client=made.client, transport=made.transport, content=made.content, gateway=made.gateway, kept=held, token=token
    )
