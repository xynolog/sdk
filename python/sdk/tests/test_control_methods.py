"""The launcher's control API as generated: each method and notification is control/methods.json's row."""

from pathlib import PurePosixPath
from typing import get_args

from spec import SPEC, objects, read, text

from xynolog import types as wire
from xynolog.control import ControlSender
from xynolog.control_methods import CONTROL_API_VERSION, CONTROL_METHODS, CONTROL_NOTIFICATIONS

TABLE = read(SPEC / "control/methods.json")


def model(schema_id: str) -> object:
    """The model of `types` a row names by its schema's `$id`."""
    return getattr(wire, PurePosixPath(schema_id).stem)


def test_the_version_is_the_one_its_schema_admits() -> None:
    (admitted,) = get_args(get_args(wire.ApiVersion.__value__)[0])
    assert model(text(TABLE["apiVersion"], "apiVersion")) is wire.ApiVersion
    assert admitted == CONTROL_API_VERSION


def test_each_notification_is_its_rows_name_sender_and_params() -> None:
    rows = objects(TABLE["notifications"], "notifications")
    assert [text(row["name"], "a name") for row in rows] == list(CONTROL_NOTIFICATIONS)
    for row in rows:
        held = CONTROL_NOTIFICATIONS[text(row["name"], "a name")]
        assert (held.name, held.sent_by, held.params) == (row["name"], row["from"], model(text(row["params"], "params")))


def test_each_method_is_its_rows_name_models_exclusivity_and_notifications() -> None:
    rows = objects(TABLE["methods"], "methods")
    assert [text(row["name"], "a name") for row in rows] == list(CONTROL_METHODS)
    for row in rows:
        held = CONTROL_METHODS[text(row["name"], "a name")]
        assert (held.name, held.params, held.result, held.exclusive) == (
            row["name"],
            model(text(row["params"], "params")),
            model(text(row["result"], "result")),
            row["exclusive"],
        )
        assert [sent.name for sent in held.sends] == row["sends"]
        assert all(sent is CONTROL_NOTIFICATIONS[sent.name] for sent in held.sends)


def test_the_senders_are_those_the_tables_schema_admits() -> None:
    schema = read(SPEC / "control/ControlMethods.json")
    properties = schema["properties"]
    assert isinstance(properties, dict)
    notifications = properties["notifications"]
    assert isinstance(notifications, dict)
    item = notifications["items"]
    assert isinstance(item, dict)
    members = item["properties"]
    assert isinstance(members, dict)
    sender = members["from"]
    assert isinstance(sender, dict)
    assert list(get_args(ControlSender.__value__)) == sender["enum"]
