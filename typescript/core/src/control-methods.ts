// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/control/methods.json
// Regenerate:  make generate  (codegen/lib/typescript_types/typescript_types.ml)

import type { components } from './types';

/** The version of the control API these tables state. */
export const CONTROL_API_VERSION = 'control.xynolog.org/v1alpha1' as const;

/** Each notification of the control API: who sends it, and the schema of its params. */
export const CONTROL_NOTIFICATIONS = {
  /** A line of what a request is doing. */
  'notifications/progress': { from: 'launcher', params: 'Progress' },
  /** A sign-in waits for a person to enter a code. */
  'notifications/userAction': { from: 'launcher', params: 'UserAction' },
  /** A line a followed service wrote. */
  'notifications/log': { from: 'launcher', params: 'LogRecord' },
  /** A run's instance is running. */
  'notifications/serviceStarted': {
    from: 'launcher',
    params: 'ServiceStarted',
  },
  /** A line a run's instance wrote. */
  'notifications/serviceOutput': { from: 'launcher', params: 'ServiceOutput' },
  /** The client gives up on a request. */
  'notifications/cancelled': { from: 'client', params: 'Cancelled' },
} as const satisfies {
  [key: string]: {
    readonly from: components['schemas']['ControlSender'];
    readonly params: keyof components['schemas'];
  };
};

/** A notification of the control API, by its name. */
export type ControlNotification = keyof typeof CONTROL_NOTIFICATIONS;

/** Each method of the control API: the schemas of its params and its result, whether it runs alone, and the notifications it sends while it runs. */
export const CONTROL_METHODS = {
  /**
   * What the launcher is: its version, the API versions it speaks, the runtimes
   * it detects. It reads none of the machine's state.
   */
  'launcher.about': {
    params: 'AboutParams',
    result: 'AboutResult',
    exclusive: false,
    sends: [],
  },
  /** Every knowledge base this machine knows: xynolog roots. */
  'roots.list': {
    params: 'RootsListParams',
    result: 'RootsListResult',
    exclusive: true,
    sends: [],
  },
  /** Create and register a new local knowledge base: xynolog init. */
  'roots.init': {
    params: 'RootsInitParams',
    result: 'RootsInitResult',
    exclusive: true,
    sends: ['notifications/progress'],
  },
  /** Remove one registry row, and no file: xynolog forget. */
  'roots.forget': {
    params: 'RootsForgetParams',
    result: 'RootsForgetResult',
    exclusive: true,
    sends: [],
  },
  /**
   * Each knowledge base's stack, and the services they share: xynolog status.
   */
  'status.snapshot': {
    params: 'StatusSnapshotParams',
    result: 'StatusSnapshotResult',
    exclusive: true,
    sends: [],
  },
  /** Start a stack, or some of its services: xynolog start. */
  'stack.start': {
    params: 'StackStartParams',
    result: 'StackStartResult',
    exclusive: true,
    sends: [],
  },
  /** Stop a stack, or some of its services: xynolog stop. */
  'stack.stop': {
    params: 'StackStopParams',
    result: 'StackStopResult',
    exclusive: true,
    sends: [],
  },
  /**
   * Sign in at the issuer a stack's knowledge base trusts, by the device grant,
   * and keep the session in the launcher's store: xynolog login. Exclusive
   * while it finds the stack; the wait for the person is not.
   */
  'auth.login': {
    params: 'AuthLoginParams',
    result: 'AuthLoginResult',
    exclusive: true,
    sends: ['notifications/userAction'],
  },
  /** End the launcher's session for a stack: xynolog logout. */
  'auth.logout': {
    params: 'AuthLogoutParams',
    result: 'AuthLogoutResult',
    exclusive: true,
    sends: [],
  },
  /**
   * Create an account in a local knowledge base's launcher-managed Keycloak
   * realm: xynolog useradd. A supplied password is secret request data and is
   * never narrated or persisted; a generated password is returned once in the
   * result.
   */
  'identity.useradd': {
    params: 'IdentityUseraddParams',
    result: 'IdentityUseraddResult',
    exclusive: true,
    sends: [],
  },
  /**
   * List accounts in one local knowledge base's launcher-managed Keycloak
   * realm. Passwords and tokens are never returned.
   */
  'identity.users.list': {
    params: 'IdentityUsersListParams',
    result: 'IdentityUsersListResult',
    exclusive: true,
    sends: [],
  },
  /**
   * Follow a stack's service logs until the client cancels or every source
   * ends: xynolog logs. Exclusive while it finds the containers; the follow is
   * not.
   */
  'logs.follow': {
    params: 'LogsFollowParams',
    result: 'LogsFollowResult',
    exclusive: true,
    sends: ['notifications/log'],
  },
  /** Every setting the launcher keeps: xynolog settings. */
  'settings.list': {
    params: 'SettingsListParams',
    result: 'SettingsListResult',
    exclusive: true,
    sends: [],
  },
  /** One setting: xynolog settings <name>. */
  'settings.get': {
    params: 'SettingsGetParams',
    result: 'Setting',
    exclusive: true,
    sends: [],
  },
  /**
   * Set a setting, checked as a start would check it: xynolog settings <name>
   * <value>.
   */
  'settings.set': {
    params: 'SettingsSetParams',
    result: 'Setting',
    exclusive: true,
    sends: [],
  },
  /** Return a setting to its default: xynolog settings <name> --unset. */
  'settings.unset': {
    params: 'SettingsUnsetParams',
    result: 'Setting',
    exclusive: true,
    sends: [],
  },
  /** Where a machine document is: xynolog settings <document> --path. */
  'settings.path': {
    params: 'SettingsPathParams',
    result: 'SettingsPathResult',
    exclusive: true,
    sends: [],
  },
  /**
   * Where this machine and a run's instance meet under a runtime: the host
   * address an instance's ports are published on and its dials of this machine
   * go to. A caller asks it before it writes an instance's document.
   */
  'service.host': {
    params: 'ServiceHostParams',
    result: 'ServiceHostResult',
    exclusive: false,
    sends: [],
  },
  /**
   * Run one instance of a knowledge base's own service once, from the image its
   * stack documents name, unsupervised, on the caller's document, arguments,
   * environment and mounts, and answer when it exits: xynolog run. Exclusive
   * until its container runs; the wait for its exit is not.
   */
  'service.run': {
    params: 'ServiceRunParams',
    result: 'ServiceRunResult',
    exclusive: true,
    sends: ['notifications/serviceStarted', 'notifications/serviceOutput'],
  },
  /**
   * Send a run's instance SIGTERM, then SIGKILL if it outlives 15 seconds, or
   * SIGKILL at once: xynolog signal.
   */
  'service.signal': {
    params: 'ServiceSignalParams',
    result: 'ServiceSignalResult',
    exclusive: false,
    sends: [],
  },
} as const satisfies {
  [key: string]: {
    readonly params: keyof components['schemas'];
    readonly result: keyof components['schemas'];
    readonly exclusive: boolean;
    readonly sends: readonly ControlNotification[];
  };
};

/** A method of the control API, by its name. */
export type ControlMethod = keyof typeof CONTROL_METHODS;

/** What a method of the control API is asked with. */
export type ControlParams<M extends keyof typeof CONTROL_METHODS> =
  components['schemas'][(typeof CONTROL_METHODS)[M]['params']];

/** What a method of the control API answers. */
export type ControlResult<M extends keyof typeof CONTROL_METHODS> =
  components['schemas'][(typeof CONTROL_METHODS)[M]['result']];

/** What a notification of the control API carries. */
export type ControlNotificationParams<
  N extends keyof typeof CONTROL_NOTIFICATIONS,
> = components['schemas'][(typeof CONTROL_NOTIFICATIONS)[N]['params']];

/** What a failed request of the control API carries as its error's data. */
export type ControlErrorData = components['schemas']['ErrorData'];
