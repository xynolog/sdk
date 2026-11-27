"""The first fault of a value as one of the protocol's shapes, said in none of its own words.

Every SDK holds what it reads to the table of what each component schema
requires (`xynolog._required_table`, written by the rules of
codegen/lib/required/shape.ml) before it decodes it, and
names the first fault it finds the same way: a member the value lacks, or
one that is not what its schema allows, by the names the schema gives the
way to it. A member that holds a text none of the texts it is `recognized`
as is no fault: it is read as absent, and what is decoded is the value as
read, without it. What a
decoder refuses that the table does not state is a fault of the value
itself. Whatever decodes a value shows, in its account of a failure, what it
was given (the token an answer grants, what a person wrote), and a failure
is printed and logged: so nothing said of a fault is the value's own.

A service that reads a protocol shape the SDK does not read for it (its own
configuration, a request it answers) reads it here, and asks `bounds_of` the
sizes and bounds the table states of a member rather than restating them.
"""

from collections.abc import Callable
from dataclasses import dataclass
from typing import Final, Literal, TypeAliasType, final

from pydantic import BaseModel, Field, JsonValue, TypeAdapter, ValidationError

from xynolog._required_table import SCHEMAS
from xynolog.model import Empty, Response, WireModel
from xynolog.types import Fault

__all__ = ["UNDECODED", "Bounds", "as_read", "bounds_of", "fault_of", "read_as", "said", "within"]

type _Kind = Literal["object", "array", "string", "integer", "number", "boolean", "null"]


class _Discriminator(BaseModel, frozen=True, extra="forbid"):
    """The member whose value names the variant a union is."""

    property: str
    mapping: dict[str, int]


class _Step(BaseModel, frozen=True, extra="forbid"):
    """A step of a pattern: at least `least` of a text's next code points, and at most `most` (None: any number).

    Each is in one of the ranges `of`, from and to, both included.
    """

    of: tuple[tuple[int, int], ...]
    least: int = Field(alias="min")
    most: int | None = Field(default=None, alias="max")


class _Group(BaseModel, frozen=True, extra="forbid"):
    """A group of a pattern: a text's next code points one of the series of terms `either`.

    It is repeated at least `least` times and at most `most` (None: any
    number), a repetition past `least` taking at least one code point.
    """

    either: tuple[tuple["_Step | _Group", ...], ...]
    least: int = Field(alias="min")
    most: int | None = Field(default=None, alias="max")


class _Shape(BaseModel, frozen=True, extra="forbid"):
    """What a value must be: codegen/lib/required/shape.ml states what each part means."""

    ref: str | None = None
    kinds: tuple[_Kind, ...] | None = None
    recognized: tuple[str, ...] | None = None
    """Of an object's member, the texts it is read as: one that holds another text is read as absent."""
    enum: tuple[JsonValue, ...] | None = None
    pattern: tuple[_Step | _Group, ...] | None = None
    min_length: int | None = Field(default=None, alias="minLength")
    max_length: int | None = Field(default=None, alias="maxLength")
    minimum: float | None = None
    maximum: float | None = None
    min_items: int | None = Field(default=None, alias="minItems")
    max_items: int | None = Field(default=None, alias="maxItems")
    required: tuple[str, ...] | None = None
    members: dict[str, "_Shape"] | None = None
    closed: tuple[str, ...] | None = None
    """The only members an object may carry; None, where it may carry any."""
    items: "_Shape | None" = None
    values: "_Shape | None" = None
    one_of: tuple["_Shape", ...] | None = Field(default=None, alias="oneOf")
    discriminator: _Discriminator | None = None
    all_of: tuple["_Shape", ...] | None = Field(default=None, alias="allOf")
    not_all: tuple[tuple[str, ...], ...] | None = Field(default=None, alias="notAll")
    """Sets of members an object does not carry all of, a member that holds null being carried."""
    min_members: int | None = Field(default=None, alias="minMembers")
    names: "_Shape | None" = None
    """What each of an object's members' names must be."""


_SCHEMAS: Final = TypeAdapter(dict[str, _Shape]).validate_json(SCHEMAS)
_JSON: Final = TypeAdapter[JsonValue](JsonValue)


def within(fault: Fault, name: str) -> Fault:
    """`fault` as one of the value that holds the faulty value as its member `name`: the value itself is that member."""
    return Fault(member=name if fault.member == "" else f"{name}.{fault.member}", reason=fault.reason)


def said(fault: Fault) -> str:
    """What every SDK says of the fault."""
    if fault.reason == "lacks":
        return f"it has no `{fault.member}`"
    return "it is malformed" if fault.member == "" else f"its `{fault.member}` is malformed"


UNDECODED: Final = Fault(member="", reason="malformed")
"""The fault of a value its decoder refuses that has no fault the table states: the value itself is malformed."""


def _shape_of(declared: object) -> _Shape:
    """What a value of `declared` must be: a shape of the protocol, a union of them, `Response` of one, or `Empty`."""
    if declared is Empty:
        return _Shape(kinds=("object",))
    if isinstance(declared, type) and issubclass(declared, Response):
        (answered,) = declared.__pydantic_generic_metadata__["args"]
        return _Shape(kinds=("object",), required=("response",), members={"response": _shape_of(answered)})
    if not ((isinstance(declared, type) and issubclass(declared, WireModel)) or isinstance(declared, TypeAliasType)):
        raise TypeError(f"{declared!r} is no shape of the protocol")
    if declared.__name__ not in _SCHEMAS:
        raise TypeError(f"{declared.__name__} is no component schema of the spec")
    return _Shape(ref=declared.__name__)


@final
@dataclass(frozen=True, slots=True)
class Bounds:
    """The sizes and bounds a member's schema states, each None where it states none.

    A text's length counts code points; an array's size counts its items.
    """

    min_length: int | None
    max_length: int | None
    minimum: float | None
    maximum: float | None
    min_items: int | None
    max_items: int | None


def _resolved(shape: _Shape) -> _Shape:
    """`shape`, or the component it refers to."""
    while shape.ref is not None:
        shape = _SCHEMAS[shape.ref]
    return shape


def _allows(kinds: tuple[_Kind, ...] | None, value: JsonValue) -> bool:
    """Whether `kinds` allow `value`: none allow any, and an integer is a number with no fractional part."""
    if kinds is None:
        return True
    if value is None:
        return "null" in kinds
    if isinstance(value, bool):
        return "boolean" in kinds
    if isinstance(value, int):
        return "integer" in kinds or "number" in kinds
    if isinstance(value, float):
        return "number" in kinds or ("integer" in kinds and value.is_integer())
    if isinstance(value, str):
        return "string" in kinds
    if isinstance(value, dict):
        return "object" in kinds
    return "array" in kinds


def _within(way: str, name: str) -> str:
    return name if way == "" else f"{way}.{name}"


def _counted(least: float | None, count: float, most: float | None) -> bool:
    """Whether `count` is at least `least` and at most `most`, where each is stated."""
    return (least is None or count >= least) and (most is None or count <= most)


def _series(terms: tuple[_Step | _Group, ...], text: str, at: int, rest: Callable[[int], bool]) -> bool:
    """Whether the code points of `text` from `at` are of `terms`, with `rest` taking what is left after them.

    A step takes as many of them as it may and gives them back one by one, and
    a group repeats as often as it may and gives repetitions back the same way,
    until `rest` takes what is left.
    """
    if not terms:
        return rest(at)
    first, after_first = terms[0], terms[1:]

    def then(after: int) -> bool:
        return _series(after_first, text, after, rest)

    if isinstance(first, _Group):
        return _repeated(first, text, at, 0, then)
    taken = 0
    while (
        at + taken < len(text)
        and (first.most is None or taken < first.most)
        and any(low <= ord(text[at + taken]) <= high for low, high in first.of)
    ):
        taken += 1
    return any(then(at + count) for count in range(taken, first.least - 1, -1))


def _repeated(group: _Group, text: str, at: int, count: int, then: Callable[[int], bool]) -> bool:
    """Whether the code points of `text` from `at` are of `group`, repeated `count` times already, repeated more, then of `then`.

    The group repeats as often as it may and gives repetitions back one by
    one, a repetition past its `least` taking at least one code point.
    """
    if group.most is None or count < group.most:

        def again(after: int) -> bool:
            return (count < group.least or after > at) and _repeated(group, text, after, count + 1, then)

        for alternative in group.either:
            if _series(alternative, text, at, again):
                return True
    return count >= group.least and then(at)


def _is_as_stated(shape: _Shape, value: JsonValue) -> bool:
    """Whether `value` is one of `shape`'s values, and is of its form, its sizes and its bounds.

    An object's size is how many members it carries.

    A number is one of the values where it is equal to one in value; a
    boolean is never a number.
    """
    if shape.enum is not None and not any(one == value and isinstance(one, bool) == isinstance(value, bool) for one in shape.enum):
        return False
    if isinstance(value, str):
        end = len(value)
        return _counted(shape.min_length, end, shape.max_length) and (
            shape.pattern is None or _series(shape.pattern, value, 0, lambda at: at == end)
        )
    if isinstance(value, int | float) and not isinstance(value, bool):
        return _counted(shape.minimum, value, shape.maximum)
    if isinstance(value, list):
        return _counted(shape.min_items, len(value), shape.max_items)
    if isinstance(value, dict):
        return _counted(shape.min_members, len(value), None)
    return True


def _read_at(shape: _Shape, value: JsonValue, way: str) -> JsonValue | Fault:
    """`value` as it is read as a value of `shape`, from `way`; or its first fault."""
    own = _resolved(shape)
    if not _allows(own.kinds, value) or not _is_as_stated(own, value):
        return Fault(member=way, reason="malformed")
    read = value
    if isinstance(value, dict):
        members = _read_members(own, value, way)
        if isinstance(members, Fault):
            return members
        read = members
    if isinstance(read, list) and own.items is not None:
        items: list[JsonValue] = []
        for item in read:
            item_read = _read_at(own.items, item, way)
            if isinstance(item_read, Fault):
                return item_read
            items.append(item_read)
        read = items
    if own.one_of is not None:
        variant_read = _read_one_of(own, read, way)
        if isinstance(variant_read, Fault):
            return variant_read
        read = variant_read
    for part in own.all_of or ():
        part_read = _read_at(part, read, way)
        if isinstance(part_read, Fault):
            return part_read
        read = part_read
    return read


def _read_members(shape: _Shape, value: dict[str, JsonValue], way: str) -> dict[str, JsonValue] | Fault:
    """An object as it is read, or its first fault.

    Its faults are in the members `shape` requires, in what they are, in the
    members it may not carry, in their names, in the sets of them it may not
    carry all of, and in its values.

    A member `recognized` as texts, that holds a text none of them, is read as
    absent: it is no fault, and what is read does not carry it.
    """
    members = shape.members or {}
    for name in shape.required or ():
        if name not in value or (value[name] is None and name in members and not _allows(_resolved(members[name]).kinds, None)):
            return Fault(member=_within(way, name), reason="lacks")
    read = dict(value)
    for name, member in members.items():
        if name not in value:
            continue
        held = value[name]
        recognized = _resolved(member).recognized
        if recognized is not None and isinstance(held, str) and held not in recognized:
            del read[name]
            continue
        member_read = _read_at(member, held, _within(way, name))
        if isinstance(member_read, Fault):
            return member_read
        read[name] = member_read
    if shape.closed is not None:
        unnamed = min((name for name in value if name not in shape.closed), default=None)
        if unnamed is not None:
            return Fault(member=_within(way, unnamed), reason="malformed")
    if shape.names is not None:
        for name in sorted(value):
            if isinstance(_read_at(shape.names, name, ""), Fault):
                return Fault(member=_within(way, name), reason="malformed")
    for together in shape.not_all or ():
        if all(name in value for name in together):
            return Fault(member=way, reason="malformed")
    if shape.values is not None:
        for key in sorted(read):
            value_read = _read_at(shape.values, read[key], way)
            if isinstance(value_read, Fault):
                return value_read
            read[key] = value_read
    return read


def _read_one_of(shape: _Shape, value: JsonValue, way: str) -> JsonValue | Fault:
    """`value` as it is read as one of the variants of `shape`, or its fault.

    The variant its discriminator names, or else each variant whose kinds
    allow it: read as the first of them that has no fault, the first one's
    fault when each has one, and a value no variant allows is malformed.
    """
    variants = shape.one_of or ()
    candidates = [variant for variant in variants if _allows(_resolved(variant).kinds, value)]
    if isinstance(value, dict) and shape.discriminator is not None:
        named = value.get(shape.discriminator.property)
        if isinstance(named, str) and named in shape.discriminator.mapping:
            candidates = [variants[shape.discriminator.mapping[named]]]
    if not candidates:
        return Fault(member=way, reason="malformed")
    faults: list[Fault] = []
    for candidate in candidates:
        read = _read_at(candidate, value, way)
        if not isinstance(read, Fault):
            return read
        faults.append(read)
    return faults[0]


def as_read(declared: object, value: JsonValue) -> JsonValue | Fault:
    """`value` as it is read as a `declared`, by the rules every SDK reads the table by; or its first fault.

    What is read is `value` without each member it reads as absent: what a
    reader decodes. `declared` is a shape of the protocol or a union of
    them, by the name `xynolog.types` gives it, `Response` of one, or
    `Empty`.
    """
    return _read_at(_shape_of(declared), value, "")


def fault_of(declared: object, value: JsonValue) -> Fault | None:
    """The first fault `value` has as a `declared` (`as_read`); None when it has none."""
    read = as_read(declared, value)
    return read if isinstance(read, Fault) else None


def read_as[T](declared: object, text: str | bytes, decode: Callable[[JsonValue], T]) -> T | Fault:
    """The JSON `text` read as a `declared` and decoded by `decode`, or the first fault that keeps it from being one.

    `decode` is given the value as it is read (`as_read`). A text that is no
    JSON, and one `decode` refuses with no fault the table states, is
    malformed.
    """
    try:
        value = _JSON.validate_json(text)
    except ValidationError:
        return UNDECODED
    read = as_read(declared, value)
    if isinstance(read, Fault):
        return read
    try:
        return decode(read)
    except ValidationError:
        return UNDECODED


def _member_of(shape: _Shape, name: str) -> _Shape | None:
    """The member `name` of a value of `shape`, of its array's items, or of a part it is all of; None where none names it."""
    own = _resolved(shape)
    while own.items is not None:
        own = _resolved(own.items)
    if own.members is not None and name in own.members:
        return own.members[name]
    return next((found for part in own.all_of or () if (found := _member_of(part, name)) is not None), None)


def bounds_of(declared: object, member: str) -> Bounds:
    """The bounds the table states of `member` of a `declared`.

    `member` is the way to it, as a fault names one: the names of the members
    it is within and its own, joined by dots, where a member of an array's
    items is named as one of the array's, and a member of a part a value is
    all of as one of the value's. `declared` is as `as_read` takes it.
    A way that names a member its object does not is a programming error.
    """
    shape = _shape_of(declared)
    for name in member.split("."):
        within = _member_of(shape, name)
        if within is None:
            raise KeyError(f"{declared!r} has no member {member}")
        shape = within
    shape = _resolved(shape)
    return Bounds(
        min_length=shape.min_length,
        max_length=shape.max_length,
        minimum=shape.minimum,
        maximum=shape.maximum,
        min_items=shape.min_items,
        max_items=shape.max_items,
    )
