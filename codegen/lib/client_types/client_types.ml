(* The client types group: the shapes an SDK hands its callers that no wire
   message carries (protocol/specs/src/client/types), and the form a service
   account posts with a client secret (session/ClientSecretForm.json), for the
   Haskell SDK. *)

module Model = Model
module Haskell = Haskell

(* The members a FrameRefusal always holds, as its schema requires them. *)
let holds (spec : Spec.t) =
  let file = Model.types ^ "FrameRefusal.json" in
  match List.assoc_opt file spec.schemas with
  | Some (Schema.Schema { required = Some members; _ }) -> Ok members
  | _ ->
      Error
        [
          {
            Decode.file;
            pointer = "/required";
            message = "states no members a refusal always holds";
          };
        ]

let files ~root:_ (spec : Spec.t) =
  Result.bind (Model.derive spec) (fun t ->
      let shape = Model.shape t in
      Result.map List.concat
        (Spec.all
           [
             Result.map
               (fun file -> [ file ])
               (Haskell.pending_annotation ~shape);
             Result.map (fun file -> [ file ]) (Haskell.search_state ~shape);
             Result.map
               (fun file -> [ file ])
               (Result.bind (holds spec) (fun holds ->
                    Haskell.operation_reports ~shape ~holds));
             Result.map
               (fun file -> [ file ])
               (Haskell.service_proof ~grant_type:t.grant_type t.form);
           ]))
