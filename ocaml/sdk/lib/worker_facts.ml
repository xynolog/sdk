(* Generated from protocol/specs/src/client/surface.json and bus/registry.json. Do not edit.
   Regenerate: make generate (codegen/lib/worker_channels/ocaml.ml) *)

let job_claim_channels =
  [
    Bus_registry.Channel Bus_registry.Channels.job_claimed;
    Bus_registry.Channel Bus_registry.Channels.job_claim_failed;
    Bus_registry.Channel Bus_registry.Channels.job_queued;
    Bus_registry.Channel Bus_registry.Channels.job_cancel_requested;
  ]

let job_commit_channels =
  [
    Bus_registry.Channel Bus_registry.Channels.mark_commit_ok;
    Bus_registry.Channel Bus_registry.Channels.mark_commit_failed;
    Bus_registry.Channel Bus_registry.Channels.browse_annotation_result;
    Bus_registry.Channel Bus_registry.Channels.browse_annotation_failed;
  ]
