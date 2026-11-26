"""What the surface test's calls (surface_calls.py, generated) read a case's arguments with.

Each argument is read as its parameter's type, by a pydantic adapter.
"""

from collections.abc import Awaitable, Mapping
from typing import Protocol

from pydantic import JsonValue
from spec import JsonObject

from xynolog.bus import Typed
from xynolog.cached import Cached
from xynolog.client import XynologClient
from xynolog.model import WireModel, written
from xynolog.testing import FaultyTransport
from xynolog.transport import FrameRefusal

type Client = XynologClient[FaultyTransport]
type Args = Mapping[str, JsonValue]


class Reads[T](Protocol):
    """What reads a value of type `T` from what a case states."""

    def validate_python(self, value: object, /) -> T: ...


def given[T](args: Args, name: str, reads: Reads[T]) -> T:
    """The argument `name` the case must state, read as its type."""
    assert name in args, f"the case states no {name}"
    return reads.validate_python(args[name])


def maybe[T](args: Args, name: str, reads: Reads[T]) -> T | None:
    """The argument `name` read as its type, or None when the case leaves it out."""
    return reads.validate_python(args[name]) if name in args else None


def member[T](args: Args, parameter: str, name: str, reads: Reads[T]) -> T | None:
    """The member `name` of the object the case states for `parameter`, or None when it leaves either out."""
    stated = args.get(parameter, {})
    assert isinstance(stated, dict), f"{parameter} is not an object"
    return reads.validate_python(stated[name]) if name in stated else None


def fresh[T](query: Cached[T]) -> Awaitable[T]:
    """A query's value now, from the service."""
    return query.fresh()


async def first_payload[P: WireModel](events: Typed[P]) -> JsonObject:
    """The payload of the next event, as the wire would carry it. A refusal of it fails the case."""
    heard = await anext(events)
    if isinstance(heard, FrameRefusal):
        raise AssertionError(f"a payload on {heard.channel} was refused: its `{heard.member}` {heard.reason}")
    return written(heard.payload)
