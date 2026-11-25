(* Generated from protocol/specs/src/client/surface.json and client/types. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/held_job_members.ml) *)

module Held_job_record = struct
  module type S = sig
    type held

    val record : held -> Records.Held_job_record.t
    val job_id : held -> Identifiers.Job_id.t
    val job_type : held -> Enums.Job_type.t
    val resource_id : held -> Identifiers.Resource_id.t
    val params : held -> [ `JobParams ] Models.t
    val completed_units : held -> string list
    val unit_cursors : held -> (string * [ `UnitCursor ] Models.t) list
    val retry_count : held -> int
    val max_retries : held -> int
  end

  module Make (Held : sig
    type t

    val record : t -> Records.Held_job_record.t
  end) : S with type held := Held.t = struct
    let record = Held.record
    let job_id held = (Held.record held).Records.Held_job_record.job_id
    let job_type held = (Held.record held).Records.Held_job_record.job_type

    let resource_id held =
      (Held.record held).Records.Held_job_record.resource_id

    let params held = (Held.record held).Records.Held_job_record.params

    let completed_units held =
      (Held.record held).Records.Held_job_record.completed_units

    let unit_cursors held =
      (Held.record held).Records.Held_job_record.unit_cursors

    let retry_count held =
      (Held.record held).Records.Held_job_record.retry_count

    let max_retries held =
      (Held.record held).Records.Held_job_record.max_retries
  end
end
