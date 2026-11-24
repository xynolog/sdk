"""Matching, run for whoever asks on the client's own bus.

A search is asked for by a signal (`client.match.request_search`), which carries
a correlation id. This unit runs it, and answers on the same bus under the same
id: `match:search-results`, or `match:search-failed` with the reference it was
for and what went wrong. It holds no state of its own: what it found is what it
said.
"""

from types import TracebackType
from typing import Final, Self, final, override

from xynolog.bus import Delivered, Typed
from xynolog.channels import MATCH_SEARCH_FAILED, MATCH_SEARCH_REQUESTED, MATCH_SEARCH_RESULTS
from xynolog.client import XynologClient
from xynolog.errors import XynologError
from xynolog.state._tasks import Tasks
from xynolog.state_unit import StateUnit
from xynolog.transport import FrameRefusal, Transport
from xynolog.types import MatchSearchFailed, MatchSearchRequest

__all__ = ["MatchStateUnit"]


@final
class MatchStateUnit(StateUnit):
    """See the module's documentation."""

    def __init__(self, client: XynologClient[Transport]) -> None:
        self._client: Final = client
        self._tasks: Final = Tasks()
        # Taken now, so that a search asked for from here on is heard.
        self._tasks.run(self._listen(client.bus.frames(MATCH_SEARCH_REQUESTED)))

    async def _listen(self, heard: Typed[MatchSearchRequest]) -> None:
        async with heard:
            async for asked in heard:
                match asked:
                    case Delivered():
                        self._tasks.run(self._search(asked.payload, asked.correlation_id))
                    case FrameRefusal():
                        # A request that is not a search's names nothing to search for.
                        pass

    async def _search(self, request: MatchSearchRequest, correlation_id: str | None) -> None:
        try:
            found = await self._client.match.search(
                request.resource_id,
                request.reference_id,
                request.context,
                limit=request.limit,
                use_semantic_scoring=request.use_semantic_scoring,
            )
        except XynologError as error:
            failed = MatchSearchFailed(reference_id=request.reference_id, message=error.message)
            self._client.bus.publish(MATCH_SEARCH_FAILED, failed, correlation_id=correlation_id)
            return
        self._client.bus.publish(MATCH_SEARCH_RESULTS, found, correlation_id=correlation_id)

    @override
    def dispose(self) -> None:
        self._tasks.stop()

    async def __aenter__(self) -> Self:
        return self

    async def __aexit__(self, kind: type[BaseException] | None, error: BaseException | None, trace: TracebackType | None) -> None:
        self.dispose()
        await self._tasks.ended()
