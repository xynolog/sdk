# Generated from protocol/specs/src/control/methods.json; do not edit.
# Regenerate: make generate (codegen/lib/python_types/python_types.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The launcher's control API: its version, each of its notifications, and each of its methods,
with the models of what each carries. A request that fails carries its error's data as
`ErrorData`.
"""

from collections.abc import Mapping
from types import MappingProxyType
from typing import Final

from xynolog.control import AnyControlMethod, AnyControlNotification, ControlMethod, ControlNotification
from xynolog.types import (
    AboutParams,
    AboutResult,
    ApiVersion,
    AuthLoginParams,
    AuthLoginResult,
    AuthLogoutParams,
    AuthLogoutResult,
    Cancelled,
    IdentityUseraddParams,
    IdentityUseraddResult,
    IdentityUsersListParams,
    IdentityUsersListResult,
    LogRecord,
    LogsFollowParams,
    LogsFollowResult,
    Progress,
    RootsForgetParams,
    RootsForgetResult,
    RootsInitParams,
    RootsInitResult,
    RootsListParams,
    RootsListResult,
    ServiceHostParams,
    ServiceHostResult,
    ServiceOutput,
    ServiceRunParams,
    ServiceRunResult,
    ServiceSignalParams,
    ServiceSignalResult,
    ServiceStarted,
    Setting,
    SettingsGetParams,
    SettingsListParams,
    SettingsListResult,
    SettingsPathParams,
    SettingsPathResult,
    SettingsSetParams,
    SettingsUnsetParams,
    StackStartParams,
    StackStartResult,
    StackStopParams,
    StackStopResult,
    StatusSnapshotParams,
    StatusSnapshotResult,
    UserAction,
)

__all__ = [
    "AUTH_LOGIN",
    "AUTH_LOGOUT",
    "CONTROL_API_VERSION",
    "CONTROL_METHODS",
    "CONTROL_NOTIFICATIONS",
    "IDENTITY_USERADD",
    "IDENTITY_USERS_LIST",
    "LAUNCHER_ABOUT",
    "LOGS_FOLLOW",
    "NOTIFICATIONS_CANCELLED",
    "NOTIFICATIONS_LOG",
    "NOTIFICATIONS_PROGRESS",
    "NOTIFICATIONS_SERVICE_OUTPUT",
    "NOTIFICATIONS_SERVICE_STARTED",
    "NOTIFICATIONS_USER_ACTION",
    "ROOTS_FORGET",
    "ROOTS_INIT",
    "ROOTS_LIST",
    "SERVICE_HOST",
    "SERVICE_RUN",
    "SERVICE_SIGNAL",
    "SETTINGS_GET",
    "SETTINGS_LIST",
    "SETTINGS_PATH",
    "SETTINGS_SET",
    "SETTINGS_UNSET",
    "STACK_START",
    "STACK_STOP",
    "STATUS_SNAPSHOT",
]

CONTROL_API_VERSION: Final[ApiVersion] = "control.xynolog.org/v1alpha1"
"""The version of the control API these tables state, which every request's params state."""

NOTIFICATIONS_PROGRESS: Final = ControlNotification[Progress](
    name="notifications/progress",
    sent_by="launcher",
    params=Progress,
)
"""A line of what a request is doing."""

NOTIFICATIONS_USER_ACTION: Final = ControlNotification[UserAction](
    name="notifications/userAction",
    sent_by="launcher",
    params=UserAction,
)
"""A sign-in waits for a person to enter a code."""

NOTIFICATIONS_LOG: Final = ControlNotification[LogRecord](
    name="notifications/log",
    sent_by="launcher",
    params=LogRecord,
)
"""A line a followed service wrote."""

NOTIFICATIONS_SERVICE_STARTED: Final = ControlNotification[ServiceStarted](
    name="notifications/serviceStarted",
    sent_by="launcher",
    params=ServiceStarted,
)
"""A run's instance is running."""

NOTIFICATIONS_SERVICE_OUTPUT: Final = ControlNotification[ServiceOutput](
    name="notifications/serviceOutput",
    sent_by="launcher",
    params=ServiceOutput,
)
"""A line a run's instance wrote."""

NOTIFICATIONS_CANCELLED: Final = ControlNotification[Cancelled](
    name="notifications/cancelled",
    sent_by="client",
    params=Cancelled,
)
"""The client gives up on a request."""

LAUNCHER_ABOUT: Final = ControlMethod[AboutParams, AboutResult](
    name="launcher.about",
    params=AboutParams,
    result=AboutResult,
    exclusive=False,
    sends=(),
)
"""What the launcher is: its version, the API versions it speaks, the runtimes it detects. It reads
none of the machine's state.
"""

ROOTS_LIST: Final = ControlMethod[RootsListParams, RootsListResult](
    name="roots.list",
    params=RootsListParams,
    result=RootsListResult,
    exclusive=True,
    sends=(),
)
"""Every knowledge base this machine knows: xynolog roots."""

ROOTS_INIT: Final = ControlMethod[RootsInitParams, RootsInitResult](
    name="roots.init",
    params=RootsInitParams,
    result=RootsInitResult,
    exclusive=True,
    sends=(NOTIFICATIONS_PROGRESS,),
)
"""Create and register a new local knowledge base: xynolog init."""

ROOTS_FORGET: Final = ControlMethod[RootsForgetParams, RootsForgetResult](
    name="roots.forget",
    params=RootsForgetParams,
    result=RootsForgetResult,
    exclusive=True,
    sends=(),
)
"""Remove one registry row, and no file: xynolog forget."""

STATUS_SNAPSHOT: Final = ControlMethod[StatusSnapshotParams, StatusSnapshotResult](
    name="status.snapshot",
    params=StatusSnapshotParams,
    result=StatusSnapshotResult,
    exclusive=True,
    sends=(),
)
"""Each knowledge base's stack, and the services they share: xynolog status."""

STACK_START: Final = ControlMethod[StackStartParams, StackStartResult](
    name="stack.start",
    params=StackStartParams,
    result=StackStartResult,
    exclusive=True,
    sends=(),
)
"""Start a stack, or some of its services: xynolog start."""

STACK_STOP: Final = ControlMethod[StackStopParams, StackStopResult](
    name="stack.stop",
    params=StackStopParams,
    result=StackStopResult,
    exclusive=True,
    sends=(),
)
"""Stop a stack, or some of its services: xynolog stop."""

AUTH_LOGIN: Final = ControlMethod[AuthLoginParams, AuthLoginResult](
    name="auth.login",
    params=AuthLoginParams,
    result=AuthLoginResult,
    exclusive=True,
    sends=(NOTIFICATIONS_USER_ACTION,),
)
"""Sign in at the issuer a stack's knowledge base trusts, by the device grant, and keep the session
in the launcher's store: xynolog login. Exclusive while it finds the stack; the wait for the
person is not.
"""

AUTH_LOGOUT: Final = ControlMethod[AuthLogoutParams, AuthLogoutResult](
    name="auth.logout",
    params=AuthLogoutParams,
    result=AuthLogoutResult,
    exclusive=True,
    sends=(),
)
"""End the launcher's session for a stack: xynolog logout."""

IDENTITY_USERADD: Final = ControlMethod[IdentityUseraddParams, IdentityUseraddResult](
    name="identity.useradd",
    params=IdentityUseraddParams,
    result=IdentityUseraddResult,
    exclusive=True,
    sends=(),
)
"""Create an account in a local knowledge base's launcher-managed Keycloak realm: xynolog useradd.
A supplied password is secret request data and is never narrated or persisted; a generated
password is returned once in the result.
"""

IDENTITY_USERS_LIST: Final = ControlMethod[IdentityUsersListParams, IdentityUsersListResult](
    name="identity.users.list",
    params=IdentityUsersListParams,
    result=IdentityUsersListResult,
    exclusive=True,
    sends=(),
)
"""List accounts in one local knowledge base's launcher-managed Keycloak realm. Passwords and
tokens are never returned.
"""

LOGS_FOLLOW: Final = ControlMethod[LogsFollowParams, LogsFollowResult](
    name="logs.follow",
    params=LogsFollowParams,
    result=LogsFollowResult,
    exclusive=True,
    sends=(NOTIFICATIONS_LOG,),
)
"""Follow a stack's service logs until the client cancels or every source ends: xynolog logs.
Exclusive while it finds the containers; the follow is not.
"""

SETTINGS_LIST: Final = ControlMethod[SettingsListParams, SettingsListResult](
    name="settings.list",
    params=SettingsListParams,
    result=SettingsListResult,
    exclusive=True,
    sends=(),
)
"""Every setting the launcher keeps: xynolog settings."""

SETTINGS_GET: Final = ControlMethod[SettingsGetParams, Setting](
    name="settings.get",
    params=SettingsGetParams,
    result=Setting,
    exclusive=True,
    sends=(),
)
"""One setting: xynolog settings <name>."""

SETTINGS_SET: Final = ControlMethod[SettingsSetParams, Setting](
    name="settings.set",
    params=SettingsSetParams,
    result=Setting,
    exclusive=True,
    sends=(),
)
"""Set a setting, checked as a start would check it: xynolog settings <name> <value>."""

SETTINGS_UNSET: Final = ControlMethod[SettingsUnsetParams, Setting](
    name="settings.unset",
    params=SettingsUnsetParams,
    result=Setting,
    exclusive=True,
    sends=(),
)
"""Return a setting to its default: xynolog settings <name> --unset."""

SETTINGS_PATH: Final = ControlMethod[SettingsPathParams, SettingsPathResult](
    name="settings.path",
    params=SettingsPathParams,
    result=SettingsPathResult,
    exclusive=True,
    sends=(),
)
"""Where a machine document is: xynolog settings <document> --path."""

SERVICE_HOST: Final = ControlMethod[ServiceHostParams, ServiceHostResult](
    name="service.host",
    params=ServiceHostParams,
    result=ServiceHostResult,
    exclusive=False,
    sends=(),
)
"""Where this machine and a run's instance meet under a runtime: the host address an instance's
ports are published on and its dials of this machine go to. A caller asks it before it writes an
instance's document.
"""

SERVICE_RUN: Final = ControlMethod[ServiceRunParams, ServiceRunResult](
    name="service.run",
    params=ServiceRunParams,
    result=ServiceRunResult,
    exclusive=True,
    sends=(NOTIFICATIONS_SERVICE_STARTED, NOTIFICATIONS_SERVICE_OUTPUT),
)
"""Run one instance of a knowledge base's own service once, from the image its stack documents
name, unsupervised, on the caller's document, arguments, environment and mounts, and answer when
it exits: xynolog run. Exclusive until its container runs; the wait for its exit is not.
"""

SERVICE_SIGNAL: Final = ControlMethod[ServiceSignalParams, ServiceSignalResult](
    name="service.signal",
    params=ServiceSignalParams,
    result=ServiceSignalResult,
    exclusive=False,
    sends=(),
)
"""Send a run's instance SIGTERM, then SIGKILL if it outlives 15 seconds, or SIGKILL at once:
xynolog signal.
"""

# Every notification, by its name: for code that is given a name and not a constant.
CONTROL_NOTIFICATIONS: Final[Mapping[str, AnyControlNotification]] = MappingProxyType(
    {
        "notifications/progress": NOTIFICATIONS_PROGRESS,
        "notifications/userAction": NOTIFICATIONS_USER_ACTION,
        "notifications/log": NOTIFICATIONS_LOG,
        "notifications/serviceStarted": NOTIFICATIONS_SERVICE_STARTED,
        "notifications/serviceOutput": NOTIFICATIONS_SERVICE_OUTPUT,
        "notifications/cancelled": NOTIFICATIONS_CANCELLED,
    }
)

# Every method, by its name: for code that is given a name and not a constant.
CONTROL_METHODS: Final[Mapping[str, AnyControlMethod]] = MappingProxyType(
    {
        "launcher.about": LAUNCHER_ABOUT,
        "roots.list": ROOTS_LIST,
        "roots.init": ROOTS_INIT,
        "roots.forget": ROOTS_FORGET,
        "status.snapshot": STATUS_SNAPSHOT,
        "stack.start": STACK_START,
        "stack.stop": STACK_STOP,
        "auth.login": AUTH_LOGIN,
        "auth.logout": AUTH_LOGOUT,
        "identity.useradd": IDENTITY_USERADD,
        "identity.users.list": IDENTITY_USERS_LIST,
        "logs.follow": LOGS_FOLLOW,
        "settings.list": SETTINGS_LIST,
        "settings.get": SETTINGS_GET,
        "settings.set": SETTINGS_SET,
        "settings.unset": SETTINGS_UNSET,
        "settings.path": SETTINGS_PATH,
        "service.host": SERVICE_HOST,
        "service.run": SERVICE_RUN,
        "service.signal": SERVICE_SIGNAL,
    }
)
