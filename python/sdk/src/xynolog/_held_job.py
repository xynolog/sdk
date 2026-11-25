# Generated from protocol/specs/src/client/surface.json and its client types; do not edit.
# Regenerate: make generate (codegen/lib/held_job/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The members of a held job that are its record's, as client/surface.json names the record."""

from __future__ import annotations

from collections.abc import Mapping, Sequence

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from xynolog.identifiers import JobId, ResourceId
    from xynolog.types import HeldJobRecord, JobParams, JobType, UnitCursor


class HeldJobRecordMembers:
    """The members of a held job that are its `HeldJobRecord`'s: each is the property of its name."""

    record: HeldJobRecord

    @property
    def job_id(self) -> JobId:
        return self.record.job_id

    @property
    def job_type(self) -> JobType:
        return self.record.job_type

    @property
    def resource_id(self) -> ResourceId:
        return self.record.resource_id

    @property
    def params(self) -> JobParams:
        return self.record.params

    @property
    def completed_units(self) -> Sequence[str]:
        """The units a worker has finished, merged across checkpoints and failures as a set."""
        return self.record.completed_units

    @property
    def unit_cursors(self) -> Mapping[str, UnitCursor]:
        """The furthest each unit begun got, keyed by unit, with what it had counted there. A
        finished unit keeps its cursor: where it ended, and its final counts.
        """
        return self.record.unit_cursors

    @property
    def retry_count(self) -> int:
        return self.record.retry_count

    @property
    def max_retries(self) -> int:
        """How many transient failures the queue retries: 0 for generation, whose re-run produces
        different content; 1 for every other type.
        """
        return self.record.max_retries
