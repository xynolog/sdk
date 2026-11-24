-- Generated from protocol/specs/src/control/methods.json; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Control (ControlSender (..), ControlMethod (..), ControlNotification (..), launcherAbout, rootsList, rootsInit, rootsForget, statusSnapshot, stackStart, stackStop, authLogin, authLogout, identityUseradd, identityUsersList, logsFollow, settingsList, settingsGet, settingsSet, settingsUnset, settingsPath, serviceHost, serviceRun, serviceSignal, notificationsProgress, notificationsUserAction, notificationsLog, notificationsServiceStarted, notificationsServiceOutput, notificationsCancelled) where

import Data.Text (Text)
import Xynolog.Types (AboutParams, AboutResult, AuthLoginParams, AuthLoginResult, AuthLogoutParams, AuthLogoutResult, Cancelled, IdentityUseraddParams, IdentityUseraddResult, IdentityUsersListParams, IdentityUsersListResult, LogRecord, LogsFollowParams, LogsFollowResult, Progress, RootsForgetParams, RootsForgetResult, RootsInitParams, RootsInitResult, RootsListParams, RootsListResult, ServiceHostParams, ServiceHostResult, ServiceOutput, ServiceRunParams, ServiceRunResult, ServiceSignalParams, ServiceSignalResult, ServiceStarted, Setting, SettingsGetParams, SettingsListParams, SettingsListResult, SettingsPathParams, SettingsPathResult, SettingsSetParams, SettingsUnsetParams, StackStartParams, StackStartResult, StackStopParams, StackStopResult, StatusSnapshotParams, StatusSnapshotResult, UserAction)

-- | Which side of the control API sends a notification.
data ControlSender = ControlSenderClient | ControlSenderLauncher deriving (Eq, Show)

-- | A method of the control API: a request whose params are a @params@, answered with a @result@.
data ControlMethod params result = ControlMethod
  { controlMethodName :: Text,
    controlMethodExclusive :: Bool,
    controlMethodSends :: [Text]
  }
  deriving (Eq, Show)

-- | A notification of the control API, whose params are a @params@.
data ControlNotification params = ControlNotification
  { controlNotificationName :: Text,
    controlNotificationFrom :: ControlSender
  }
  deriving (Eq, Show)

-- | What the launcher is: its version, the API versions it speaks, the runtimes it detects. It reads none of the machine's state.
launcherAbout :: ControlMethod AboutParams AboutResult
launcherAbout = ControlMethod {controlMethodName = "launcher.about", controlMethodExclusive = False, controlMethodSends = []}

-- | Every knowledge base this machine knows: xynolog roots.
rootsList :: ControlMethod RootsListParams RootsListResult
rootsList = ControlMethod {controlMethodName = "roots.list", controlMethodExclusive = True, controlMethodSends = []}

-- | Create and register a new local knowledge base: xynolog init.
rootsInit :: ControlMethod RootsInitParams RootsInitResult
rootsInit = ControlMethod {controlMethodName = "roots.init", controlMethodExclusive = True, controlMethodSends = ["notifications/progress"]}

-- | Remove one registry row, and no file: xynolog forget.
rootsForget :: ControlMethod RootsForgetParams RootsForgetResult
rootsForget = ControlMethod {controlMethodName = "roots.forget", controlMethodExclusive = True, controlMethodSends = []}

-- | Each knowledge base's stack, and the services they share: xynolog status.
statusSnapshot :: ControlMethod StatusSnapshotParams StatusSnapshotResult
statusSnapshot = ControlMethod {controlMethodName = "status.snapshot", controlMethodExclusive = True, controlMethodSends = []}

-- | Start a stack, or some of its services: xynolog start.
stackStart :: ControlMethod StackStartParams StackStartResult
stackStart = ControlMethod {controlMethodName = "stack.start", controlMethodExclusive = True, controlMethodSends = []}

-- | Stop a stack, or some of its services: xynolog stop.
stackStop :: ControlMethod StackStopParams StackStopResult
stackStop = ControlMethod {controlMethodName = "stack.stop", controlMethodExclusive = True, controlMethodSends = []}

-- | Sign in at the issuer a stack's knowledge base trusts, by the device grant, and keep the session in the launcher's store: xynolog login. Exclusive while it finds the stack; the wait for the person is not.
authLogin :: ControlMethod AuthLoginParams AuthLoginResult
authLogin = ControlMethod {controlMethodName = "auth.login", controlMethodExclusive = True, controlMethodSends = ["notifications/userAction"]}

-- | End the launcher's session for a stack: xynolog logout.
authLogout :: ControlMethod AuthLogoutParams AuthLogoutResult
authLogout = ControlMethod {controlMethodName = "auth.logout", controlMethodExclusive = True, controlMethodSends = []}

-- | Create an account in a local knowledge base's launcher-managed Keycloak realm: xynolog useradd. A supplied password is secret request data and is never narrated or persisted; a generated password is returned once in the result.
identityUseradd :: ControlMethod IdentityUseraddParams IdentityUseraddResult
identityUseradd = ControlMethod {controlMethodName = "identity.useradd", controlMethodExclusive = True, controlMethodSends = []}

-- | List accounts in one local knowledge base's launcher-managed Keycloak realm. Passwords and tokens are never returned.
identityUsersList :: ControlMethod IdentityUsersListParams IdentityUsersListResult
identityUsersList = ControlMethod {controlMethodName = "identity.users.list", controlMethodExclusive = True, controlMethodSends = []}

-- | Follow a stack's service logs until the client cancels or every source ends: xynolog logs. Exclusive while it finds the containers; the follow is not.
logsFollow :: ControlMethod LogsFollowParams LogsFollowResult
logsFollow = ControlMethod {controlMethodName = "logs.follow", controlMethodExclusive = True, controlMethodSends = ["notifications/log"]}

-- | Every setting the launcher keeps: xynolog settings.
settingsList :: ControlMethod SettingsListParams SettingsListResult
settingsList = ControlMethod {controlMethodName = "settings.list", controlMethodExclusive = True, controlMethodSends = []}

-- | One setting: xynolog settings <name>.
settingsGet :: ControlMethod SettingsGetParams Setting
settingsGet = ControlMethod {controlMethodName = "settings.get", controlMethodExclusive = True, controlMethodSends = []}

-- | Set a setting, checked as a start would check it: xynolog settings <name> <value>.
settingsSet :: ControlMethod SettingsSetParams Setting
settingsSet = ControlMethod {controlMethodName = "settings.set", controlMethodExclusive = True, controlMethodSends = []}

-- | Return a setting to its default: xynolog settings <name> --unset.
settingsUnset :: ControlMethod SettingsUnsetParams Setting
settingsUnset = ControlMethod {controlMethodName = "settings.unset", controlMethodExclusive = True, controlMethodSends = []}

-- | Where a machine document is: xynolog settings <document> --path.
settingsPath :: ControlMethod SettingsPathParams SettingsPathResult
settingsPath = ControlMethod {controlMethodName = "settings.path", controlMethodExclusive = True, controlMethodSends = []}

-- | Where this machine and a run's instance meet under a runtime: the host address an instance's ports are published on and its dials of this machine go to. A caller asks it before it writes an instance's document.
serviceHost :: ControlMethod ServiceHostParams ServiceHostResult
serviceHost = ControlMethod {controlMethodName = "service.host", controlMethodExclusive = False, controlMethodSends = []}

-- | Run one instance of a knowledge base's own service once, from the image its stack documents name, unsupervised, on the caller's document, arguments, environment and mounts, and answer when it exits: xynolog run. Exclusive until its container runs; the wait for its exit is not.
serviceRun :: ControlMethod ServiceRunParams ServiceRunResult
serviceRun = ControlMethod {controlMethodName = "service.run", controlMethodExclusive = True, controlMethodSends = ["notifications/serviceStarted", "notifications/serviceOutput"]}

-- | Send a run's instance SIGTERM, then SIGKILL if it outlives 15 seconds, or SIGKILL at once: xynolog signal.
serviceSignal :: ControlMethod ServiceSignalParams ServiceSignalResult
serviceSignal = ControlMethod {controlMethodName = "service.signal", controlMethodExclusive = False, controlMethodSends = []}

-- | A line of what a request is doing.
notificationsProgress :: ControlNotification Progress
notificationsProgress = ControlNotification {controlNotificationName = "notifications/progress", controlNotificationFrom = ControlSenderLauncher}

-- | A sign-in waits for a person to enter a code.
notificationsUserAction :: ControlNotification UserAction
notificationsUserAction = ControlNotification {controlNotificationName = "notifications/userAction", controlNotificationFrom = ControlSenderLauncher}

-- | A line a followed service wrote.
notificationsLog :: ControlNotification LogRecord
notificationsLog = ControlNotification {controlNotificationName = "notifications/log", controlNotificationFrom = ControlSenderLauncher}

-- | A run's instance is running.
notificationsServiceStarted :: ControlNotification ServiceStarted
notificationsServiceStarted = ControlNotification {controlNotificationName = "notifications/serviceStarted", controlNotificationFrom = ControlSenderLauncher}

-- | A line a run's instance wrote.
notificationsServiceOutput :: ControlNotification ServiceOutput
notificationsServiceOutput = ControlNotification {controlNotificationName = "notifications/serviceOutput", controlNotificationFrom = ControlSenderLauncher}

-- | The client gives up on a request.
notificationsCancelled :: ControlNotification Cancelled
notificationsCancelled = ControlNotification {controlNotificationName = "notifications/cancelled", controlNotificationFrom = ControlSenderClient}
