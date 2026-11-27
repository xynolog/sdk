"""What a method and a notification of the launcher's control API are, to a type checker and at run time.

Each method and each notification the API has is a constant of
`xynolog.control_methods`, generated from `protocol/specs/src/control/methods.json`;
what each carries is a model of `xynolog.types`.
"""

from dataclasses import dataclass
from typing import Protocol, final

from xynolog.model import WireModel
from xynolog.types import ControlSender

__all__ = ["AnyControlMethod", "AnyControlNotification", "ControlMethod", "ControlNotification"]


class AnyControlNotification(Protocol):
    """A notification, whatever it carries: what code that treats every notification alike reads of one."""

    @property
    def name(self) -> str: ...

    @property
    def sent_by(self) -> ControlSender: ...

    @property
    def params(self) -> type[WireModel]: ...


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class ControlNotification[Params: WireModel]:
    """A notification of the control API: who sends it, and the model of its params."""

    name: str
    sent_by: ControlSender
    params: type[Params]


class AnyControlMethod(Protocol):
    """A method, whatever it is asked and answers: what code that treats every method alike reads of one."""

    @property
    def name(self) -> str: ...

    @property
    def params(self) -> type[WireModel]: ...

    @property
    def result(self) -> type[WireModel]: ...

    @property
    def exclusive(self) -> bool: ...

    @property
    def sends(self) -> tuple[AnyControlNotification, ...]: ...


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class ControlMethod[Params: WireModel, Result: WireModel]:
    """A method of the control API: the models of its params and its result, whether it runs alone, and what it sends."""

    name: str
    params: type[Params]
    result: type[Result]
    exclusive: bool
    """Whether a request waits for every other exclusive request to end, and holds the others off until it does."""
    sends: tuple[AnyControlNotification, ...]
    """The notifications a request may send besides `notifications/progress`, which any may send."""
