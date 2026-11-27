(* Generated from protocol/specs/src/control/methods.json. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/control.ml) *)

module Method = struct
  type ('params, 'result) t = {
    name : string;
    exclusive : bool;
    sends : string list;
    params : 'params Models.descriptor;
    result : 'result Models.descriptor;
  }
end

module Notification = struct
  type 'params t = {
    name : string;
    from : Enums.Control_sender.t;
    params : 'params Models.descriptor;
  }
end

let launcher_about : ([ `AboutParams ], [ `AboutResult ]) Method.t =
  {
    Method.name = "launcher.about";
    exclusive = false;
    sends = [];
    params = Models.about_params;
    result = Models.about_result;
  }

let roots_list : ([ `RootsListParams ], [ `RootsListResult ]) Method.t =
  {
    Method.name = "roots.list";
    exclusive = true;
    sends = [];
    params = Models.roots_list_params;
    result = Models.roots_list_result;
  }

let roots_init : ([ `RootsInitParams ], [ `RootsInitResult ]) Method.t =
  {
    Method.name = "roots.init";
    exclusive = true;
    sends = [ "notifications/progress" ];
    params = Models.roots_init_params;
    result = Models.roots_init_result;
  }

let roots_forget : ([ `RootsForgetParams ], [ `RootsForgetResult ]) Method.t =
  {
    Method.name = "roots.forget";
    exclusive = true;
    sends = [];
    params = Models.roots_forget_params;
    result = Models.roots_forget_result;
  }

let status_snapshot :
    ([ `StatusSnapshotParams ], [ `StatusSnapshotResult ]) Method.t =
  {
    Method.name = "status.snapshot";
    exclusive = true;
    sends = [];
    params = Models.status_snapshot_params;
    result = Models.status_snapshot_result;
  }

let stack_start : ([ `StackStartParams ], [ `StackStartResult ]) Method.t =
  {
    Method.name = "stack.start";
    exclusive = true;
    sends = [];
    params = Models.stack_start_params;
    result = Models.stack_start_result;
  }

let stack_stop : ([ `StackStopParams ], [ `StackStopResult ]) Method.t =
  {
    Method.name = "stack.stop";
    exclusive = true;
    sends = [];
    params = Models.stack_stop_params;
    result = Models.stack_stop_result;
  }

let auth_login : ([ `AuthLoginParams ], [ `AuthLoginResult ]) Method.t =
  {
    Method.name = "auth.login";
    exclusive = true;
    sends = [ "notifications/userAction" ];
    params = Models.auth_login_params;
    result = Models.auth_login_result;
  }

let auth_logout : ([ `AuthLogoutParams ], [ `AuthLogoutResult ]) Method.t =
  {
    Method.name = "auth.logout";
    exclusive = true;
    sends = [];
    params = Models.auth_logout_params;
    result = Models.auth_logout_result;
  }

let identity_useradd :
    ([ `IdentityUseraddParams ], [ `IdentityUseraddResult ]) Method.t =
  {
    Method.name = "identity.useradd";
    exclusive = true;
    sends = [];
    params = Models.identity_useradd_params;
    result = Models.identity_useradd_result;
  }

let identity_users_list :
    ([ `IdentityUsersListParams ], [ `IdentityUsersListResult ]) Method.t =
  {
    Method.name = "identity.users.list";
    exclusive = true;
    sends = [];
    params = Models.identity_users_list_params;
    result = Models.identity_users_list_result;
  }

let logs_follow : ([ `LogsFollowParams ], [ `LogsFollowResult ]) Method.t =
  {
    Method.name = "logs.follow";
    exclusive = true;
    sends = [ "notifications/log" ];
    params = Models.logs_follow_params;
    result = Models.logs_follow_result;
  }

let settings_list : ([ `SettingsListParams ], [ `SettingsListResult ]) Method.t
    =
  {
    Method.name = "settings.list";
    exclusive = true;
    sends = [];
    params = Models.settings_list_params;
    result = Models.settings_list_result;
  }

let settings_get : ([ `SettingsGetParams ], [ `Setting ]) Method.t =
  {
    Method.name = "settings.get";
    exclusive = true;
    sends = [];
    params = Models.settings_get_params;
    result = Models.setting;
  }

let settings_set : ([ `SettingsSetParams ], [ `Setting ]) Method.t =
  {
    Method.name = "settings.set";
    exclusive = true;
    sends = [];
    params = Models.settings_set_params;
    result = Models.setting;
  }

let settings_unset : ([ `SettingsUnsetParams ], [ `Setting ]) Method.t =
  {
    Method.name = "settings.unset";
    exclusive = true;
    sends = [];
    params = Models.settings_unset_params;
    result = Models.setting;
  }

let settings_path : ([ `SettingsPathParams ], [ `SettingsPathResult ]) Method.t
    =
  {
    Method.name = "settings.path";
    exclusive = true;
    sends = [];
    params = Models.settings_path_params;
    result = Models.settings_path_result;
  }

let service_host : ([ `ServiceHostParams ], [ `ServiceHostResult ]) Method.t =
  {
    Method.name = "service.host";
    exclusive = false;
    sends = [];
    params = Models.service_host_params;
    result = Models.service_host_result;
  }

let service_run : ([ `ServiceRunParams ], [ `ServiceRunResult ]) Method.t =
  {
    Method.name = "service.run";
    exclusive = true;
    sends = [ "notifications/serviceStarted"; "notifications/serviceOutput" ];
    params = Models.service_run_params;
    result = Models.service_run_result;
  }

let service_signal :
    ([ `ServiceSignalParams ], [ `ServiceSignalResult ]) Method.t =
  {
    Method.name = "service.signal";
    exclusive = false;
    sends = [];
    params = Models.service_signal_params;
    result = Models.service_signal_result;
  }

let notifications_progress : [ `Progress ] Notification.t =
  {
    Notification.name = "notifications/progress";
    from = Enums.Control_sender.Launcher;
    params = Models.progress;
  }

let notifications_user_action : [ `UserAction ] Notification.t =
  {
    Notification.name = "notifications/userAction";
    from = Enums.Control_sender.Launcher;
    params = Models.user_action;
  }

let notifications_log : [ `LogRecord ] Notification.t =
  {
    Notification.name = "notifications/log";
    from = Enums.Control_sender.Launcher;
    params = Models.log_record;
  }

let notifications_service_started : [ `ServiceStarted ] Notification.t =
  {
    Notification.name = "notifications/serviceStarted";
    from = Enums.Control_sender.Launcher;
    params = Models.service_started;
  }

let notifications_service_output : [ `ServiceOutput ] Notification.t =
  {
    Notification.name = "notifications/serviceOutput";
    from = Enums.Control_sender.Launcher;
    params = Models.service_output;
  }

let notifications_cancelled : [ `Cancelled ] Notification.t =
  {
    Notification.name = "notifications/cancelled";
    from = Enums.Control_sender.Client;
    params = Models.cancelled;
  }
