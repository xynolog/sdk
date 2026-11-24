"""The match unit: what its cases in `protocol/specs/src/client/state-units.json` cannot state.

Its behaviour is the table's, run by `tests/test_state_cases.py`. Here are the
axioms: it holds no state, and is given its client.
"""

from typing import final, override

from aio import run, turns

from xynolog.channels import BRIDGED_CHANNELS
from xynolog.operations import MATCH_SEARCH_REQUESTED
from xynolog.state import MatchStateUnit
from xynolog.testing import DropReply, FaultyTransport, create_test_client
from xynolog.testing.axioms import AxiomSubject, Fresh, assert_state_unit_axioms
from xynolog.types import GatheredContext, MatchSearchOptions, MatchSearchRequest


@final
class Matches(AxiomSubject[MatchStateUnit]):
    """How the axioms reach a match unit: over a client's stream, where nothing answers."""

    @override
    def setup(self) -> Fresh[MatchStateUnit]:
        made = create_test_client(
            transport=FaultyTransport([DropReply()], make_response=lambda operation, payload: None, channels=BRIDGED_CHANNELS)
        )
        return Fresh(MatchStateUnit(made.client)).given(made.client)


def test_match_keeps_the_state_unit_axioms() -> None:
    assert_state_unit_axioms(Matches())


def test_a_search_asked_for_is_sent_with_every_option_its_request_states() -> None:
    stated = MatchSearchOptions(limit=3, use_semantic_scoring=False)
    assert stated.model_fields_set == set(MatchSearchOptions.model_fields), "an option a search takes that this test does not state"
    context = GatheredContext.model_validate(
        {
            "focus": {
                "kind": "resource",
                "resource": {"@context": "https://schema.org", "@id": "res-1", "name": "A", "representations": []},
            },
            "graph": {"nodes": [], "edges": []},
            "metadata": {},
        }
    )
    asked = MatchSearchRequest.model_validate(
        {"resourceId": "res-1", "referenceId": "ann-1", "context": context, **stated.model_dump(by_alias=True)}
    )

    async def scenario() -> None:
        made = create_test_client()
        async with made.client, MatchStateUnit(made.client):
            made.client.match.request_search(asked, correlation_id="c1")
            await turns()
            sent = [frame.payload for frame in made.transport.emitted if frame.channel == MATCH_SEARCH_REQUESTED.request.name]
            options = stated.model_dump(by_alias=True)
            assert [{name: payload.get(name) for name in options} for payload in sent] == [options]
        await made.transport.close()

    run(scenario())
