(* Generated from protocol/specs/src/sign-in-store/cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type cases_item = {
  why : string;
  os : string;
  home : string option;
  xdg_state_home : string option;
  local_app_data : string option;
  dir : string option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("os", (fun s -> `String s) r.os);
         Option.Some
           ( "home",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.home );
         Option.Some
           ( "xdgStateHome",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.xdg_state_home );
         Option.map
           (fun v -> ("localAppData", (fun s -> `String s) v))
           r.local_app_data;
         Option.Some
           ( "dir",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.dir );
       ])

type kept = { token : string; refresh_token : string }

let kept_json (r : kept) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("token", (fun s -> `String s) r.token);
         Option.Some ("refreshToken", (fun s -> `String s) r.refresh_token);
       ])

type when_ = Before | During

let when__value = function
  | (Before : when_) -> "before"
  | (During : when_) -> "during"

let when__json v = `String (when__value v)

type does = Renews | Signs_out

let does_value = function
  | (Renews : does) -> "renews"
  | (Signs_out : does) -> "signs-out"

let does_json v = `String (does_value v)

type meanwhile = { when_ : when_; does : does; theirs : kept option }

let meanwhile_json (r : meanwhile) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("when", when__json r.when_);
         Option.Some ("does", does_json r.does);
         Option.map (fun v -> ("theirs", kept_json v)) r.theirs;
       ])

type issues = { token : string; refresh_token : string option }

let issues_json (r : issues) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("token", (fun s -> `String s) r.token);
         Option.map
           (fun v -> ("refreshToken", (fun s -> `String s) v))
           r.refresh_token;
       ])

type renewals_item = {
  why : string;
  kept : kept;
  holding : string option;
  meanwhile : meanwhile option;
  expired : string list;
  issues : issues;
  spends : string option;
  leaves : kept option;
  gives : string option;
}

let renewals_item_json (r : renewals_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("kept", kept_json r.kept);
         Option.Some
           ( "holding",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.holding );
         Option.Some
           ( "meanwhile",
             (function
               | Option.None -> `Null | Option.Some v -> meanwhile_json v)
               r.meanwhile );
         Option.Some
           ( "expired",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.expired );
         Option.Some ("issues", issues_json r.issues);
         Option.Some
           ( "spends",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.spends );
         Option.Some
           ( "leaves",
             (function Option.None -> `Null | Option.Some v -> kept_json v)
               r.leaves );
         Option.Some
           ( "gives",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.gives );
       ])

type t = {
  comment : string;
  cases : cases_item list;
  renewals : renewals_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
         Option.Some
           ( "renewals",
             (fun l -> `List (List.map renewals_item_json l)) r.renewals );
       ])

let table : t =
  ({
     comment =
       "Two tables, which each SDK that reads the store runs. `cases`: where \
        the launcher's state home is: the directory that holds tokens.json \
        (and the launcher's own stack.json and discovery/kbs.json). Every \
        program that finds those files computes it the same way. `os` is \
        `macos`, `windows`, or anything else; `home` is the home directory \
        (HOME, or USERPROFILE on Windows), `xdgStateHome` is XDG_STATE_HOME, \
        null when it is not set, and `localAppData` is LOCALAPPDATA, left out \
        when it is not set. `dir` null means there is no state home, and \
        nothing is read or written. `dir` is written with the system's own \
        separator, whatever system computes it: a backslash on Windows, a \
        slash elsewhere. Each SDK runs every case against its reader of the \
        state home, which is given what the environment says and reads none \
        itself: a program that finds its state home through an SDK's reads the \
        environment for it. `renewals`: what a renewal of a kept sign-in \
        writes and gives, when other programs renew the same stack and sign it \
        out (README.md, Renewing it). A row's store holds `kept` for the stack \
        when the row begins, and its renewer holds the access token `holding`, \
        null for none: the one the gateway refused, the one due, or the one \
        found expired at a session's start (specs/src/session/cases.json). \
        `meanwhile` is what another program does to the stack's sign-in, null \
        for nothing: it `renews` (its own renewal, or a sign-in again), \
        leaving `theirs`, or it `signs-out`; `before` the renewal reads the \
        store, or `during` the renewal's grant, after its read and before its \
        write. The issuer answers a grant with `issues`, which has no \
        `refreshToken` when the issuer rotates none. `spends` is the refresh \
        token the renewal's grant presents to the issuer, null when it makes \
        no grant; a runner fails a renewal that makes more than one. `leaves` \
        is what the store then holds for the stack, null for nothing, and \
        `gives` the access token the renewal gives its holder, null for none. \
        A sign-in here is its `token` and its `refreshToken`; a runner keeps \
        the rest as a sign-in learns it. Each access token is a name: a runner \
        mints a distinct JWT for each, naming who signed in and at which \
        issuer (`email`, `iss`) and expiring an hour from now, or an hour ago \
        when the row lists it in `expired`. A refresh token is its name. Every \
        store each SDK has, the one on disk and the one in memory, runs every \
        row, through that SDK's renewal.";
     cases =
       [
         ({
            why = "macOS: the application-support directory";
            os = "macos";
            home = Some "/Users/alice";
            xdg_state_home = None;
            local_app_data = None;
            dir = Some "/Users/alice/Library/Application Support/xynolog";
          }
           : cases_item);
         ({
            why = "macOS does not read XDG_STATE_HOME";
            os = "macos";
            home = Some "/Users/alice";
            xdg_state_home = Some "/var/state";
            local_app_data = None;
            dir = Some "/Users/alice/Library/Application Support/xynolog";
          }
           : cases_item);
         ({
            why = "elsewhere, XDG_STATE_HOME when it is set";
            os = "linux";
            home = Some "/home/alice";
            xdg_state_home = Some "/var/state";
            local_app_data = None;
            dir = Some "/var/state/xynolog";
          }
           : cases_item);
         ({
            why = "elsewhere, ~/.local/state when it is not";
            os = "linux";
            home = Some "/home/alice";
            xdg_state_home = None;
            local_app_data = None;
            dir = Some "/home/alice/.local/state/xynolog";
          }
           : cases_item);
         ({
            why = "an empty XDG_STATE_HOME is one that is not set";
            os = "linux";
            home = Some "/home/alice";
            xdg_state_home = Some "";
            local_app_data = None;
            dir = Some "/home/alice/.local/state/xynolog";
          }
           : cases_item);
         ({
            why =
              "with no home there is no state home, even where XDG_STATE_HOME \
               is set";
            os = "linux";
            home = None;
            xdg_state_home = Some "/var/state";
            local_app_data = None;
            dir = None;
          }
           : cases_item);
         ({
            why = "an empty home is no home";
            os = "linux";
            home = Some "";
            xdg_state_home = None;
            local_app_data = None;
            dir = None;
          }
           : cases_item);
         ({
            why = "macOS with no home has no state home";
            os = "macos";
            home = None;
            xdg_state_home = None;
            local_app_data = None;
            dir = None;
          }
           : cases_item);
         ({
            why = "Windows: the local application-data directory";
            os = "windows";
            home = Some "C:\\Users\\alice";
            xdg_state_home = None;
            local_app_data = Some "C:\\Users\\alice\\AppData\\Local";
            dir = Some "C:\\Users\\alice\\AppData\\Local\\xynolog";
          }
           : cases_item);
         ({
            why = "Windows follows LOCALAPPDATA where it is not under the home";
            os = "windows";
            home = Some "C:\\Users\\alice";
            xdg_state_home = None;
            local_app_data = Some "D:\\Profiles\\alice\\Local";
            dir = Some "D:\\Profiles\\alice\\Local\\xynolog";
          }
           : cases_item);
         ({
            why = "Windows does not read XDG_STATE_HOME";
            os = "windows";
            home = Some "C:\\Users\\alice";
            xdg_state_home = Some "D:\\state";
            local_app_data = Some "C:\\Users\\alice\\AppData\\Local";
            dir = Some "C:\\Users\\alice\\AppData\\Local\\xynolog";
          }
           : cases_item);
         ({
            why =
              "Windows, when LOCALAPPDATA is not set: where it is by default, \
               under the home";
            os = "windows";
            home = Some "C:\\Users\\alice";
            xdg_state_home = None;
            local_app_data = None;
            dir = Some "C:\\Users\\alice\\AppData\\Local\\xynolog";
          }
           : cases_item);
         ({
            why = "an empty LOCALAPPDATA is one that is not set";
            os = "windows";
            home = Some "C:\\Users\\alice";
            xdg_state_home = None;
            local_app_data = Some "";
            dir = Some "C:\\Users\\alice\\AppData\\Local\\xynolog";
          }
           : cases_item);
         ({
            why =
              "Windows with no home has no state home, even where LOCALAPPDATA \
               is set";
            os = "windows";
            home = None;
            xdg_state_home = None;
            local_app_data = Some "C:\\Users\\alice\\AppData\\Local";
            dir = None;
          }
           : cases_item);
         ({
            why = "elsewhere, LOCALAPPDATA is not read";
            os = "linux";
            home = Some "/home/alice";
            xdg_state_home = None;
            local_app_data = Some "C:\\Users\\alice\\AppData\\Local";
            dir = Some "/home/alice/.local/state/xynolog";
          }
           : cases_item);
       ];
     renewals =
       [
         ({
            why =
              "a renewal keeps what the issuer issued for the refresh token it \
               spent, and gives the new access token";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile = None;
            expired = [];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = Some "refresh-1";
            leaves =
              Some ({ token = "access-2"; refresh_token = "refresh-2" } : kept);
            gives = Some "access-2";
          }
           : renewals_item);
         ({
            why =
              "an issuer that rotates no refresh token issues none: the one \
               spent is kept beside the new access token";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile = None;
            expired = [];
            issues = ({ token = "access-2"; refresh_token = None } : issues);
            spends = Some "refresh-1";
            leaves =
              Some ({ token = "access-2"; refresh_token = "refresh-1" } : kept);
            gives = Some "access-2";
          }
           : renewals_item);
         ({
            why =
              "a renewal another program made while this one's grant was in \
               flight stands: this one's tokens are dropped, and it goes on \
               with the kept access token";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile =
              Some
                ({
                   when_ = (During : when_);
                   does = (Renews : does);
                   theirs =
                     Some
                       ({ token = "access-9"; refresh_token = "refresh-9" }
                         : kept);
                 }
                  : meanwhile);
            expired = [];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = Some "refresh-1";
            leaves =
              Some ({ token = "access-9"; refresh_token = "refresh-9" } : kept);
            gives = Some "access-9";
          }
           : renewals_item);
         ({
            why =
              "at an issuer that rotates no refresh token, another program's \
               renewal during this one's grant leaves the refresh token this \
               one spent, and still stands: what is kept is no longer what \
               this renewal read";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile =
              Some
                ({
                   when_ = (During : when_);
                   does = (Renews : does);
                   theirs =
                     Some
                       ({ token = "access-9"; refresh_token = "refresh-1" }
                         : kept);
                 }
                  : meanwhile);
            expired = [];
            issues = ({ token = "access-2"; refresh_token = None } : issues);
            spends = Some "refresh-1";
            leaves =
              Some ({ token = "access-9"; refresh_token = "refresh-1" } : kept);
            gives = Some "access-9";
          }
           : renewals_item);
         ({
            why =
              "another program renewed before this renewal read the store: the \
               kept access token is not the one held and has not expired, so \
               it is given as it is, and no grant is made";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile =
              Some
                ({
                   when_ = (Before : when_);
                   does = (Renews : does);
                   theirs =
                     Some
                       ({ token = "access-9"; refresh_token = "refresh-9" }
                         : kept);
                 }
                  : meanwhile);
            expired = [];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = None;
            leaves =
              Some ({ token = "access-9"; refresh_token = "refresh-9" } : kept);
            gives = Some "access-9";
          }
           : renewals_item);
         ({
            why =
              "another program renewed before this renewal read the store, and \
               the access token it left has expired: the refresh token it left \
               is spent";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile =
              Some
                ({
                   when_ = (Before : when_);
                   does = (Renews : does);
                   theirs =
                     Some
                       ({ token = "access-9"; refresh_token = "refresh-9" }
                         : kept);
                 }
                  : meanwhile);
            expired = [ "access-9" ];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = Some "refresh-9";
            leaves =
              Some ({ token = "access-2"; refresh_token = "refresh-2" } : kept);
            gives = Some "access-2";
          }
           : renewals_item);
         ({
            why =
              "a session at its start renews the kept access token it found \
               expired: it is the token held, so its refresh token is spent";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile = None;
            expired = [ "access-1" ];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = Some "refresh-1";
            leaves =
              Some ({ token = "access-2"; refresh_token = "refresh-2" } : kept);
            gives = Some "access-2";
          }
           : renewals_item);
         ({
            why =
              "a renewer that holds no token renews a kept access token that \
               has expired";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = None;
            meanwhile = None;
            expired = [ "access-1" ];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = Some "refresh-1";
            leaves =
              Some ({ token = "access-2"; refresh_token = "refresh-2" } : kept);
            gives = Some "access-2";
          }
           : renewals_item);
         ({
            why =
              "a stack signed out while the renewal's grant was in flight \
               stays signed out: nothing is written back, and the new access \
               token is given to nobody";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile =
              Some
                ({
                   when_ = (During : when_);
                   does = (Signs_out : does);
                   theirs = None;
                 }
                  : meanwhile);
            expired = [];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = Some "refresh-1";
            leaves = None;
            gives = None;
          }
           : renewals_item);
         ({
            why =
              "a stack signed out before the renewal read the store has \
               nothing to renew: no grant is made, and nothing is given";
            kept = ({ token = "access-1"; refresh_token = "refresh-1" } : kept);
            holding = Some "access-1";
            meanwhile =
              Some
                ({
                   when_ = (Before : when_);
                   does = (Signs_out : does);
                   theirs = None;
                 }
                  : meanwhile);
            expired = [];
            issues =
              ({ token = "access-2"; refresh_token = Some "refresh-2" }
                : issues);
            spends = None;
            leaves = None;
            gives = None;
          }
           : renewals_item);
       ];
   }
    : t)
