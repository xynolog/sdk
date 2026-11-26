"""SearchState, JobEvent and CacheState, generic and written by hand, held to their schemas.

The schemas are in `protocol/specs/src/client/types`. Each type's members and branches are read off the type itself, so a member or
a branch either side gains or loses fails.
"""

from dataclasses import fields
from typing import get_args, get_origin

from pydantic import JsonValue
from spec import SPEC, JsonObject, read

from xynolog.cache import CacheState
from xynolog.namespaces.follow import JobEvent, RefusedFrame
from xynolog.state.search import SearchState


def _properties(schema: JsonValue) -> set[str]:
    assert isinstance(schema, dict)
    properties = schema["properties"]
    assert isinstance(properties, dict)
    return set(properties)


def _member(schema: JsonValue, name: str) -> JsonValue:
    assert isinstance(schema, dict)
    properties = schema["properties"]
    assert isinstance(properties, dict)
    return properties[name]


def _schema(name: str) -> JsonObject:
    return read(SPEC / "client/types" / f"{name}.json")


def test_search_state_has_the_schemas_members() -> None:
    written = {info.alias or name for name, info in SearchState.model_fields.items()}
    assert written == _properties(_schema("SearchState"))


def _branches(name: str, tag: str) -> dict[str, JsonValue]:
    one_of = _schema(name)["oneOf"]
    assert isinstance(one_of, list)
    branches: dict[str, JsonValue] = {}
    for branch in one_of:
        told = _member(branch, tag)
        assert isinstance(told, dict)
        values = told["enum"]
        assert isinstance(values, list)
        assert isinstance(values[0], str)
        branches[values[0]] = branch
    return branches


def _written(union: object, tag: str) -> dict[str, set[str]]:
    written: dict[str, set[str]] = {}
    for case in get_args(union):
        held = {field.name: field for field in fields(get_origin(case) or case)}
        told = held[tag].default
        assert isinstance(told, str)
        written[told] = set(held)
    return written


def test_job_event_has_the_schemas_branches_each_of_its_members() -> None:
    branches = _branches("JobEvent", "kind")
    written = _written(JobEvent.__value__, "kind")
    assert set(written) == set(branches)
    for told, members in written.items():
        assert members == _properties(branches[told]), told
    assert {field.name for field in fields(RefusedFrame)} == _properties(_member(branches["refused"], "data"))


def test_cache_state_has_the_schemas_branches_each_of_its_members() -> None:
    branches = _branches("CacheState", "status")
    written = _written(CacheState.__value__, "status")
    assert set(written) == set(branches)
    for told, members in written.items():
        assert members == _properties(branches[told]), told
