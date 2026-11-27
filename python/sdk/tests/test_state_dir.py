"""Where the launcher's state home is, as every program that finds it computes it (`protocol/specs/src/sign-in-store/cases.json`)."""

import pytest
from pydantic import TypeAdapter
from spec import SPEC, JsonObject, objects, read, text

from xynolog.sign_in_store import state_dir
from xynolog.types import System

CASES = objects(read(SPEC / "sign-in-store/cases.json")["cases"], "cases")


def said(case: JsonObject, name: str) -> str | None:
    """What a case says the environment says. A key it leaves out is not set."""
    value = case.get(name)
    assert value is None or isinstance(value, str)
    return value


SYSTEM: TypeAdapter[System] = TypeAdapter[System](System)


@pytest.mark.parametrize("case", CASES, ids=lambda case: text(case["why"], "why"))
def test_the_state_home_is_where_the_table_says(case: JsonObject) -> None:
    found = state_dir(
        SYSTEM.validate_python(case["os"]),
        home=said(case, "home"),
        xdg_state_home=said(case, "xdgStateHome"),
        local_app_data=said(case, "localAppData"),
    )
    assert found == said(case, "dir")


def test_the_table_was_read() -> None:
    assert len(CASES) >= 15
