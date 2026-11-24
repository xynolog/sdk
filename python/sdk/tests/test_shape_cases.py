"""Reading a value as a schema, held to `protocol/specs/src/client/shape-cases.json`: the table every SDK's reading of a value runs.

Each case's value is held to the schema it names, from the value itself, and
its first fault is the one the case states, or none.
"""

from typing import Final, Literal

import pytest
from pydantic import BaseModel, Field, JsonValue
from spec import SPEC

from xynolog import types
from xynolog.required import Fault, fault_of
from xynolog.types import FrameRefusalReason


class Accepted(BaseModel, frozen=True, extra="forbid"):
    """A value that is read."""

    why: str
    schema_name: str = Field(alias="schema")
    value: JsonValue


class Refused(BaseModel, frozen=True, extra="forbid"):
    """A value that is refused, for its first fault."""

    why: str
    schema_name: str = Field(alias="schema")
    value: JsonValue
    refused: Literal[True]
    member: str
    reason: FrameRefusalReason


class Table(BaseModel, frozen=True):
    cases: list[Accepted | Refused]


TABLE: Final = Table.model_validate_json((SPEC / "client/shape-cases.json").read_bytes())


def test_the_runner_found_the_table_s_cases() -> None:
    assert TABLE.cases


@pytest.mark.parametrize("case", TABLE.cases, ids=lambda case: case.why)
def test_a_value_s_first_fault_is_what_the_table_says(case: Accepted | Refused) -> None:
    declared: object = getattr(types, case.schema_name)
    fault = Fault(member=case.member, reason=case.reason) if isinstance(case, Refused) else None
    assert fault_of(declared, case.value) == fault, case.why
