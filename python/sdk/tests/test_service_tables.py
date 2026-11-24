"""The services' tables as generated: each is its file, read as its schema's model, and none is left out."""

from spec import SPEC, read

from xynolog.service_tables import SERVICE_TABLES

AREAS = (
    "archivist",
    "dispatcher",
    "embedding",
    "gateway",
    "graph",
    "librarian",
    "smelter",
    "vectors",
    "weaver",
    "worker",
    "service-environment",
    "service-telemetry",
    "jobs",
)
"""The areas whose every table the services keep to: each service's own, and what they share."""


def test_every_table_of_the_services_areas_is_carried_but_their_cases() -> None:
    stated = {
        f"{area}/{table.name}"
        for area in AREAS
        if (SPEC / area).is_dir()
        for table in (SPEC / area).glob("[a-z]*.json")
        if not table.name.endswith("cases.json") and table.name != "openapi.json"
    }
    assert set(SERVICE_TABLES) == stated | {"bus/reply-bounds.json"}


def test_each_table_reads_back_as_its_file_says_it() -> None:
    for path, table in SERVICE_TABLES.items():
        assert table.model_dump(mode="json", by_alias=True, exclude_unset=True) == read(SPEC / path), path
