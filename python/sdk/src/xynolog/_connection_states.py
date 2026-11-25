# Generated from protocol/specs/src/client/connection-states.json; do not edit.
# Regenerate: make generate (codegen/lib/connection_states/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The states each state of a client's stream may become."""

from collections.abc import Mapping
from typing import Final

from xynolog.types import ConnectionState

__all__ = [
    "CONNECTION_STATE_MAY_BECOME",
]

# The states each state may be followed by.
CONNECTION_STATE_MAY_BECOME: Final[Mapping[ConnectionState, frozenset[ConnectionState]]] = {
    "initial": frozenset({"connecting", "unauthenticated", "closed"}),
    "connecting": frozenset({"open", "reconnecting", "unauthenticated", "closed"}),
    "open": frozenset({"reconnecting", "closed"}),
    "reconnecting": frozenset({"connecting", "degraded", "unauthenticated", "closed"}),
    "degraded": frozenset({"connecting", "unauthenticated", "closed"}),
    "unauthenticated": frozenset({"connecting", "closed"}),
    "closed": frozenset(),
}
