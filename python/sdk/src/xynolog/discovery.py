"""The knowledge bases a launcher manages, as the launcher publishes them (`protocol/specs/src/discovery`).

What the document says, read whole or not at all, and what changed since it
was last read.

**Absent is not empty.** `DiscoveryAbsent` is "no launcher was found", with
why; `DiscoveryManaged` with no knowledge bases is "the launcher is here and
manages nothing". A reader shows the two differently and never has to work
out which it has.

**A document is read whole.** One of a version this client does not speak,
or with an entry that is not what the schema says, is `DiscoveryAbsent`: a
partial reading would hide a running knowledge base without a trace.

**The address is the key.** Entries are told apart by host and port, which
the launcher keeps unique. A did is not unique: one knowledge base running in
two places is two entries with one did, and each is its own. Two entries at
one address cannot both be true, and are named in `DiscoveryDiff.duplicated`
for a reader to show rather than merged.

Where the document is read from is a `DiscoveryTransport`: `text_discovery`
is one over any way of getting the text, and `xynolog.http.discovery` has
one over a URL. Discovery only describes: signing in to a knowledge base it
lists is a person's act.
"""

import asyncio
from collections.abc import AsyncGenerator, Awaitable, Callable, Sequence
from typing import Final, Protocol, final, get_args, override

from pydantic import JsonValue, TypeAdapter, ValidationError

from xynolog._discovery_url_path import DISCOVERY_URL_PATH
from xynolog.required import fault_of
from xynolog.timing import DISCOVERY_INTERVAL_MS
from xynolog.types import (
    DiscoveredKB,
    DiscoveryAbsent,
    DiscoveryAbsentReason,
    DiscoveryDiff,
    DiscoveryDocument,
    DiscoveryManaged,
    DiscoveryRead,
    DiscoveryState,
    DiscoveryUnchanged,
)

__all__ = [
    "DISCOVERY_INTERVAL_MS",
    "DISCOVERY_URL_PATH",
    "DiscoveryAbsentReason",
    "DiscoveryTransport",
    "parse_discovery_document",
    "subscribe_discovery",
    "text_discovery",
]


def _version() -> int:
    """The version of the document this client reads: the one, and only, its schema admits."""
    match get_args(DiscoveryDocument.model_fields["version"].annotation):
        case (int() as version,):
            return version
        case admitted:
            raise TypeError(f"DiscoveryDocument admits the versions {admitted}, and this client reads one")


_VERSION: Final = _version()

_JSON: Final = TypeAdapter[JsonValue](JsonValue)


class DiscoveryTransport(Protocol):
    """Where the document is read from."""

    async def read(self) -> DiscoveryRead:
        """Read the document once."""
        ...


def _where(location: tuple[int | str, ...]) -> str:
    """A place in the document, as `kbs[1].did` names one."""
    return "".join(f"[{step}]" if isinstance(step, int) else f".{step}" for step in location).removeprefix(".")


def parse_discovery_document(text: str) -> DiscoveryState:
    """The document's text as a state. Every reader goes through this."""
    try:
        parsed = _JSON.validate_json(text)
    except ValidationError as error:
        return DiscoveryAbsent(kind="absent", reason="not-json", diagnostic=error.errors()[0]["msg"])
    if not isinstance(parsed, dict):
        return DiscoveryAbsent(kind="absent", reason="invalid", diagnostic="document is not an object")
    version = parsed.get("version")
    if isinstance(version, bool) or not isinstance(version, int):
        return DiscoveryAbsent(kind="absent", reason="invalid", diagnostic='missing numeric "version"')
    if version != _VERSION:
        return DiscoveryAbsent(
            kind="absent",
            reason="unsupported-version",
            diagnostic=f"discovery document version {version} is not the one this client speaks ({_VERSION}); it is not read in part",
        )
    if (fault := fault_of(DiscoveryDocument, parsed)) is not None:
        return DiscoveryAbsent(kind="absent", reason="invalid", diagnostic=str(fault))
    try:
        # Strictly: a port written as text, or a name written as a number, is not the schema's.
        document = DiscoveryDocument.model_validate_json(text, strict=True)
    except ValidationError as error:
        first = error.errors()[0]
        return DiscoveryAbsent(kind="absent", reason="invalid", diagnostic=f"{_where(first['loc'])}: {first['msg']}")
    return DiscoveryManaged(kind="managed", kbs=document.kbs)


@final
class _TextDiscovery(DiscoveryTransport):
    def __init__(self, read: Callable[[], Awaitable[str]]) -> None:
        self._read: Final = read

    @override
    async def read(self) -> DiscoveryRead:
        try:
            text = await self._read()
        except FileNotFoundError:
            return DiscoveryAbsent(kind="absent", reason="not-found")
        except (OSError, UnicodeDecodeError) as error:
            return DiscoveryAbsent(kind="absent", reason="unreadable", diagnostic=str(error))
        return parse_discovery_document(text)


def text_discovery(read: Callable[[], Awaitable[str]]) -> DiscoveryTransport:
    """A transport over any way of getting the document's text.

    `read` gives the text, raises `FileNotFoundError` when there is no
    document, and another `OSError`, or `UnicodeDecodeError` for text that is
    not UTF-8, when it could not be read. Reading the launcher's file with
    `Path.read_text` fails each of those ways.
    """
    return _TextDiscovery(read)


def _address(kb: DiscoveredKB) -> str:
    return f"{kb.host}:{kb.port}"


def _kbs_of(state: DiscoveryState | None) -> Sequence[DiscoveredKB]:
    """The knowledge bases a state lists: none when it is absent, or when there is no state."""
    return state.kbs if isinstance(state, DiscoveryManaged) else ()


def _diff(last: DiscoveryState | None, next_state: DiscoveryState) -> DiscoveryDiff | None:
    """What changed between `last`, the state last told of (none when none was), and `next_state`; none when nothing did."""
    before_kbs, after_kbs = _kbs_of(last), _kbs_of(next_state)
    before = {_address(kb): kb for kb in before_kbs}
    after = {_address(kb) for kb in after_kbs}

    added: list[DiscoveredKB] = []
    updated: list[DiscoveredKB] = []
    duplicated: list[str] = []
    claimed: dict[str, int] = {}
    for kb in after_kbs:
        at = _address(kb)
        claimed[at] = claimed.get(at, 0) + 1
        if claimed[at] == 2:
            duplicated.append(at)
        was = before.get(at)
        if was is None:
            added.append(kb)
        elif was != kb:
            updated.append(kb)
    removed = [kb for kb in before_kbs if _address(kb) not in after]

    match last, next_state:
        case DiscoveryManaged(), DiscoveryManaged():
            state_changed = False
        case DiscoveryAbsent(reason=why_before), DiscoveryAbsent(reason=why_now):
            state_changed = why_before != why_now
        case _:
            state_changed = True
    if not (state_changed or added or updated or removed):
        return None
    return DiscoveryDiff(state=next_state, added=added, updated=updated, removed=removed, duplicated=duplicated)


async def subscribe_discovery(transport: DiscoveryTransport, interval_ms: int = DISCOVERY_INTERVAL_MS) -> AsyncGenerator[DiscoveryDiff]:
    """Read a launcher's document now and then every `interval_ms`, and tell of each change.

    The first read is always told of. After it, a read that changed nothing
    is not: only an entry added, changed or removed, and a change of state,
    which carries every entry it brought or took away. Each iteration reads on
    its own, and reading stops when its reader stops: it reads only while it
    is being iterated, and closing it (`aclose`) ends it.
    """
    last: DiscoveryState | None = None
    while True:
        match await transport.read():
            case DiscoveryUnchanged():
                pass
            case DiscoveryAbsent() | DiscoveryManaged() as state:
                change = _diff(last, state)
                if change is not None:
                    last = change.state
                    yield change
        await asyncio.sleep(interval_ms / 1000)
