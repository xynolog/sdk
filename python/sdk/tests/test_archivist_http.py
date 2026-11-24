"""The Archivist's routes as generated: each operation of archivist/openapi.json, by its operationId."""

import re

from spec import SPEC, read, text

from xynolog.http import archivist_http
from xynolog.http.archivist_http import ArchivistRoute


def constant(operation_id: str) -> str:
    """`getHealth` → `GET_HEALTH`."""
    return re.sub(r"(?<=[a-z])(?=[A-Z])", "_", operation_id).upper()


def test_each_operation_is_a_route_of_its_method_and_path() -> None:
    document = read(SPEC / "archivist/openapi.json")
    paths = document["paths"]
    assert isinstance(paths, dict)
    stated: dict[str, ArchivistRoute] = {}
    for path, reference in paths.items():
        assert isinstance(reference, dict)
        item = read(SPEC / "archivist" / text(reference["$ref"], "a path item"))
        for method in ("get", "put", "post"):
            operation = item.get(method)
            if isinstance(operation, dict):
                stated[constant(text(operation["operationId"], "an operationId"))] = ArchivistRoute(method=method.upper(), path=path)
    held = {name: value for name, value in vars(archivist_http).items() if isinstance(value, ArchivistRoute)}
    assert held == stated
    assert set(archivist_http.__all__) == {*stated, "ArchivistRoute"}
