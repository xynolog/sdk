"""What the table of what each schema requires holds a value to, besides its kinds and its members: read as every SDK reads it."""

import pytest
from pydantic import JsonValue

from xynolog.required import Bounds, Fault, bounds_of, fault_of
from xynolog.types import (
    BrowseProfilesRequest,
    BusPingMessage,
    ConformanceStep,
    GatherAnnotationOptions,
    GenerationJobParams,
    Inference,
    Metadata,
    RunInstance,
    Target,
    WorkerConfig,
    WorkerKnowledgeBaseConfig,
)


def malformed(member: str) -> Fault:
    return Fault(member=member, reason="malformed")


def lacks(member: str) -> Fault:
    return Fault(member=member, reason="lacks")


def test_a_value_is_one_of_its_values_of_its_form_and_of_its_size() -> None:
    cases: list[tuple[object, JsonValue, Fault | None]] = [
        (BusPingMessage, {"event": "ping", "data": ""}, None),
        (BusPingMessage, {"event": "pong", "data": ""}, malformed("event")),
        (BusPingMessage, {"event": "ping", "data": "x"}, malformed("data")),
        (BrowseProfilesRequest, {"dids": ["did:web:example.org"]}, None),
        (BrowseProfilesRequest, {"dids": ["did:\U0001f600"]}, None),
        (BrowseProfilesRequest, {"dids": []}, malformed("dids")),
        (BrowseProfilesRequest, {"dids": ["web:example.org"]}, malformed("dids")),
        (BrowseProfilesRequest, {"dids": ["did:web:a b"]}, malformed("dids")),
        (GatherAnnotationOptions, {"contextWindow": 100.0}, None),
        (GatherAnnotationOptions, {"contextWindow": 5000}, None),
        (GatherAnnotationOptions, {"contextWindow": 99}, malformed("contextWindow")),
        (GatherAnnotationOptions, {"contextWindow": 5001}, malformed("contextWindow")),
    ]
    for declared, value, fault in cases:
        assert fault_of(declared, value) == fault, value


def test_a_closed_object_carries_no_member_it_does_not_name() -> None:
    assert fault_of(BrowseProfilesRequest, {"dids": ["did:web:example.org"], "more": 1}) == malformed("more")
    assert fault_of(BrowseProfilesRequest, {"dids": [], "more": 1}) == malformed("dids")
    assert fault_of(BrowseProfilesRequest, {"more": 1}) == Fault(member="dids", reason="lacks")
    assert fault_of(BrowseProfilesRequest, {"dids": ["did:web:example.org"], "\U0001f600": 1, "｡": 1}) == malformed("｡")


def test_a_patterns_group_is_one_of_its_alternatives_repeated_as_often_as_it_says() -> None:
    cases: list[tuple[object, JsonValue, Fault | None]] = [
        (ConformanceStep, {"wire": "GET /"}, None),
        (ConformanceStep, {"wire": "PATCH /kb/x"}, None),
        (ConformanceStep, {"wire": "GET /kb\nx"}, None),
        # A union none of whose variants a value is has its first variant's fault.
        (ConformanceStep, {"wire": "HEAD /"}, lacks("let")),
        (ConformanceStep, {"wire": "GET"}, lacks("let")),
        (ConformanceStep, {"wire": " GET /"}, lacks("let")),
        (RunInstance, "a", None),
        (RunInstance, "one-two-3", None),
        (RunInstance, "one--two", malformed("")),
        (RunInstance, "one-", malformed("")),
        (RunInstance, "-one", malformed("")),
        (Metadata, {"name": "a"}, None),
        (Metadata, {"name": "a-b-c"}, None),
        (Metadata, {"name": "a-"}, malformed("name")),
    ]
    for declared, value, fault in cases:
        assert fault_of(declared, value) == fault, value


def test_an_object_carries_no_set_of_members_it_may_not_carry_all_of() -> None:
    assert fault_of(Target, {"kind": "local", "root": "/x"}) is None
    assert fault_of(Target, {"kind": "codespace", "repo": "a/b"}) is None
    assert fault_of(Target, {"kind": "local", "root": "/x", "repo": "a/b"}) == malformed("")
    assert fault_of(Target, {"kind": "local", "root": "/x", "repo": None}) == malformed("")


def test_an_objects_members_are_as_many_and_named_as_it_says() -> None:
    def inference(providers: JsonValue) -> JsonValue:
        return {
            "apiVersion": "xynolog.org/v1alpha1",
            "kind": "Inference",
            "metadata": {"name": "local"},
            "spec": {"providers": providers, "engines": {"jobs": {}, "actors": {}}},
        }

    assert fault_of(Inference, inference({"anthropic": {}})) is None
    assert fault_of(Inference, inference({})) == malformed("spec.providers")
    assert fault_of(Inference, inference({"anthropic": {}, "acme": {}})) == malformed("spec.providers.acme")
    assert fault_of(Inference, inference({"anthropic": 5})) == malformed("spec.providers")
    assert fault_of(Inference, inference({"acme": 5})) == malformed("spec.providers.acme")


def test_a_members_bounds_are_the_tables() -> None:
    unbounded = Bounds(min_length=None, max_length=None, minimum=None, maximum=None, min_items=None, max_items=None)
    assert bounds_of(BrowseProfilesRequest, "dids") == Bounds(
        min_length=None, max_length=None, minimum=None, maximum=None, min_items=1, max_items=500
    )
    assert bounds_of(GatherAnnotationOptions, "contextWindow") == Bounds(
        min_length=None, max_length=None, minimum=100, maximum=5000, min_items=None, max_items=None
    )
    assert bounds_of(BusPingMessage, "event") == unbounded
    assert bounds_of(BusPingMessage, "data").max_length == 0
    assert bounds_of(WorkerKnowledgeBaseConfig, "identity.issuer").min_length == 1
    assert bounds_of(WorkerConfig, "knowledgeBases").min_items == 1
    assert bounds_of(WorkerConfig, "knowledgeBases.engines").min_items == 1
    assert bounds_of(WorkerConfig, "knowledgeBases.identity.clientId").min_length == 1
    assert bounds_of(GenerationJobParams, "storageUri").min_length == 1
    with pytest.raises(KeyError):
        bounds_of(BrowseProfilesRequest, "more")
