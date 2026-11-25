# Generated from protocol/specs/src/client/surface.json and bus/registry.json; do not edit.
# Regenerate: make generate (codegen/lib/worker_channels/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The channels a worker's stream names, as client/surface.json's constants state them."""

from typing import Final

__all__ = [
    "JOB_CLAIM_CHANNELS",
    "JOB_COMMIT_CHANNELS",
]

# The channels a stream names for client/surface.json's jobClaimChannels: the replies of
# job:claim, then job:queued and job:cancel-requested.
JOB_CLAIM_CHANNELS: Final[tuple[str, ...]] = (
    "job:claimed",
    "job:claim-failed",
    "job:queued",
    "job:cancel-requested",
)

# The channels a stream names for client/surface.json's jobCommitChannels: the replies of
# mark:commit and browse:annotation-requested.
JOB_COMMIT_CHANNELS: Final[tuple[str, ...]] = (
    "mark:commit-ok",
    "mark:commit-failed",
    "browse:annotation-result",
    "browse:annotation-failed",
)
