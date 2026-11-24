"""A moment as the protocol writes one, a schema's `date-time`: RFC 3339, in UTC, to the millisecond."""

from datetime import datetime

__all__ = ["instant"]


def instant(at: datetime) -> str:
    """`at`, a moment in UTC, as the protocol writes it."""
    return at.isoformat(timespec="milliseconds").replace("+00:00", "Z")
