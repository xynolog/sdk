# Generated from protocol/specs/src/client/option-defaults.json; do not edit.
# Regenerate: make generate (codegen/lib/option_defaults/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""What a public option of the client is when its caller leaves it out, where the client decides it."""

from typing import Final

from xynolog.types import BrowseDirectoryRequestSort, KbTarget

__all__ = [
    "BROWSE_FILES_DIR_PATH",
    "BROWSE_FILES_SORT",
    "GATHER_RESOURCE_DEPTH",
    "GATHER_RESOURCE_MAX_RESOURCES",
    "GATHER_RESOURCE_INCLUDE_CONTENT",
    "GATHER_RESOURCE_INCLUDE_SUMMARY",
    "MATCH_SEARCH_LIMIT",
    "KEPT_SIGN_IN_SESSION_FROM_KEPT_VALIDATE",
    "TESTING_CREATE_TEST_SESSION_KB",
]

BROWSE_FILES_DIR_PATH: Final = "."
"""The directory listed: the knowledge base's root."""

BROWSE_FILES_SORT: Final[BrowseDirectoryRequestSort] = "name"
"""How the listing is ordered: by name."""

GATHER_RESOURCE_DEPTH: Final = 2
"""How many links out from the resource the graph reaches."""

GATHER_RESOURCE_MAX_RESOURCES: Final = 10
"""The most resources the context holds."""

GATHER_RESOURCE_INCLUDE_CONTENT: Final = True
"""Whether the context carries the resources' text."""

GATHER_RESOURCE_INCLUDE_SUMMARY: Final = False
"""Whether the context carries a summary of the resource."""

MATCH_SEARCH_LIMIT: Final = 10
"""The most candidates the search answers."""

KEPT_SIGN_IN_SESSION_FROM_KEPT_VALIDATE: Final = True
"""Whether a session opened over a kept sign-in asks the gateway who its token is."""

TESTING_CREATE_TEST_SESSION_KB: Final = KbTarget.model_validate_json(
    '{"id":"test-kb","label":"Test KB","endpoint":{"kind":"http","host":"localhost","port":4000,"protocol":"http"}}'
)
"""The knowledge base a test session is with: test-kb, at http://localhost:4000."""
