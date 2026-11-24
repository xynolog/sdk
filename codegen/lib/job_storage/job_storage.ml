(* The job storage group: the names and subjects every implementation of the
   job queue uses on the broker (protocol/specs/src/jobs/storage.json), with
   the job types (JobType) and the motivations a mark job is told apart by
   (MarkJobParams), for the TypeScript SDK; the names alone, for the Rust
   SDK; and, for the Haskell SDK, which motivation each of MarkJobParams'
   branches is. Work queued by one
   implementation survives a switch to another only if both name these
   alike. Each name is stated; the bucket's record is a component; JobType is
   an enum of words; and MarkJobParams is told apart by a mapping, whose every
   entry names the one branch whose required motivation is that word, a word
   of Motivation. *)

module T = Tables.Jobs_storage

let file = "jobs/storage.json"
let job_type = "components/schemas/JobType.json"
let mark_params = "components/schemas/MarkJobParams.json"
let motivation = "components/schemas/Motivation.json"

type t = {
  table : T.t;
  job_types : string list;
  mark_motivations : (string * string) list;
      (** Each of MarkJobParams' branches, in their order: the component it
          names, and its motivation. *)
}

(* A schema's enum, when each of its members is a word. *)
let words = function
  | Some (Schema.Schema { enum = Some literals; _ }) ->
      let words =
        List.filter_map
          (function Schema.String_literal w -> Some w | _ -> None)
          literals
      in
      if List.length words = List.length literals then Some words else None
  | _ -> None

(* Each of MarkJobParams' branches, by the component it names, and its
   motivation, refusing a branch that
   is no plain reference to a component whose required motivation is one word
   of Motivation, the mapping naming it for that word. *)
let branch_motivations ids schemas =
  let refusals = ref [] in
  let refuse file pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  let motivations =
    match words (List.assoc_opt motivation schemas) with
    | Some words -> words
    | None ->
        refuse motivation "/enum" "is no enum of words";
        []
  in
  let held =
    match List.assoc_opt mark_params schemas with
    | Some
        (Schema.Schema
           {
             one_of = Some branches;
             discriminator =
               Some { property_name = "motivation"; mapping = Some mapping };
             _;
           }) ->
        if List.length mapping <> List.length branches then
          refuse mark_params "/discriminator/mapping"
            "does not name each branch once";
        List.concat
          (List.mapi
             (fun i branch ->
               let pointer = Printf.sprintf "/oneOf/%d" i in
               match branch with
               | Schema.Schema ({ ref_ = Some ref_; _ } as s)
                 when Schema.keywords s = [ "$ref" ] -> (
                   let target, _ = Decode.resolve ids ref_ in
                   let branch_schema = List.assoc_opt target schemas in
                   let required =
                     match branch_schema with
                     | Some (Schema.Schema { required = Some r; _ }) -> r
                     | _ -> []
                   in
                   let held =
                     match branch_schema with
                     | Some (Schema.Schema { properties = Some properties; _ })
                       ->
                         words (List.assoc_opt "motivation" properties)
                     | _ -> None
                   in
                   match held with
                   | Some [ word ]
                     when List.mem "motivation" required
                          && List.mem word motivations
                          && List.assoc_opt word mapping = Some ref_.target ->
                       [ (Definitions.stem target, word) ]
                   | _ ->
                       refuse mark_params pointer
                         "names no component whose required motivation is one \
                          word of Motivation, mapped to it";
                       [])
               | _ ->
                   refuse mark_params pointer "is no plain $ref";
                   [])
             branches)
    | _ ->
        refuse mark_params ""
          "is no oneOf told apart by a mapping of its motivation";
        []
  in
  match List.rev !refusals with [] -> Ok held | errors -> Error errors

let derive (spec : Spec.t) =
  let table = spec.tables.jobs_storage in
  let refusals = ref [] in
  let refuse file pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  List.iter
    (fun (pointer, name) -> if name = "" then refuse file pointer "is empty")
    [
      ("/stream/name", table.stream.name);
      ("/stream/subjectRoot", table.stream.subject_root);
      ("/consumer/durableName", table.consumer.durable_name);
      ("/bucket/name", table.bucket.name);
    ];
  if
    not
      (List.mem_assoc
         ("components/schemas/" ^ table.bucket.record ^ ".json")
         spec.schemas)
  then
    refuse file "/bucket/record"
      (Printf.sprintf "is %s, which is no component" table.bucket.record);
  let job_types =
    match List.assoc_opt job_type spec.schemas with
    | Some (Schema.Schema { enum = Some words; _ }) ->
        List.filter_map
          (function
            | Schema.String_literal w -> Some w
            | _ ->
                refuse job_type "/enum" "has a member that is not a word";
                None)
          words
    | _ ->
        refuse job_type "" "states no enum";
        []
  in
  match (List.rev !refusals, branch_motivations spec.ids spec.schemas) with
  | [], Ok mark_motivations -> Ok { table; job_types; mark_motivations }
  | errors, Error branch_errors -> Error (errors @ branch_errors)
  | errors, Ok _ -> Error errors

let typescript t =
  let module S = Typescript_syntax in
  let s = t.table in
  let constant ?(as_const = false) name about value =
    S.const name ~as_const ~about:[ Doc about ] value
  in
  let str text = S.Str text in
  let words = S.strings in
  {
    Output.path = "typescript/core/src/job-storage.ts";
    text =
      S.text
        {
          banner =
            Banner.typescript_lines
              ~authority:
                [
                  "protocol/specs/src/" ^ file ^ ", protocol/specs/src/"
                  ^ job_type ^ ",";
                  "protocol/specs/src/" ^ mark_params;
                ]
              __FILE__;
          body =
            [
              constant "JOBS_STREAM"
                "The work-queue stream every job is published into."
                (str s.stream.name);
              constant "JOBS_SUBJECT_ROOT"
                "The root of every job subject: a job is published on \
                 `<root>.<jobType>`."
                (str s.stream.subject_root);
              constant "JOBS_STREAM_SUBJECTS" ~as_const:true
                "The stream's capture filter: every subject under the root."
                (words [ s.stream.subject_root ^ ".>" ]);
              constant "JOBS_CONSUMER"
                "The durable consumer that holds each job's message as its \
                 lease."
                (str s.consumer.durable_name);
              constant "JOBS_BUCKET"
                ("The KV bucket holding one " ^ s.bucket.record
               ^ " per job, keyed by the job's id.")
                (str s.bucket.name);
              constant "JOB_TYPES" ~as_const:true "Every job type."
                (words t.job_types);
              constant "MARK_MOTIVATIONS" ~as_const:true
                "Every motivation a `mark` job has: the ones MarkJobParams is \
                 told apart by."
                (words (List.map snd t.mark_motivations));
            ];
        };
  }

(* Haskell's [markMotivation]: the motivation a MarkJobParams holds, by its
   branch. The branches' and motivations' constructor names are the ones
   the haskell-sdk group gives Xynolog.Types: a branch is the union's name and
   the component's. *)
let haskell t =
  let module H = Haskell_syntax in
  {
    Output.path =
      "haskell/sdk/generated/Xynolog/Internal/Generated/MarkMotivation.hs";
    text =
      H.text
        {
          banner =
            Banner.lines
              ~from_:
                ("protocol/specs/src/" ^ mark_params
               ^ " and protocol/specs/src/" ^ motivation)
              __FILE__;
          extensions = [];
          name = "Xynolog.Internal.Generated.MarkMotivation";
          imports =
            [
              H.import "Xynolog.Types"
                ~items:[ All "MarkJobParams"; All "Motivation" ];
            ];
          body =
            [
              Value
                {
                  about = [];
                  name = "markMotivation";
                  type_ = T_fun (T_name "MarkJobParams", T_name "Motivation");
                  clauses =
                    List.map
                      (fun (component, word) ->
                        {
                          H.patterns =
                            [
                              Constructor
                                ("MarkJobParams" ^ component, [ Otherwise ]);
                            ];
                          body =
                            Name ("Motivation" ^ String.capitalize_ascii word);
                        })
                      t.mark_motivations;
                };
            ];
        };
  }

(* The Rust SDK's names (rust/sdk/src/job_storage.rs), which a broker-side
   implementation of the queue uses. *)
let rust t =
  let module R = Rust_syntax in
  let s = t.table in
  let constant name about value =
    R.Const
      {
        doc = [ about ];
        attrs = [];
        vis = Pub;
        name;
        ty = R.str_ty;
        value = R.Str value;
      }
  in
  {
    Output.path = "rust/sdk/src/generated/job_storage.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__)
        [
          constant "JOBS_STREAM"
            "The work-queue stream every job is published into." s.stream.name;
          constant "JOBS_SUBJECT_ROOT"
            "The root of every job subject: a job is published on \
             `<root>.<jobType>`."
            s.stream.subject_root;
          constant "JOBS_CONSUMER"
            "The durable consumer that holds each job's message as its lease."
            s.consumer.durable_name;
          constant "JOBS_BUCKET"
            ("The key-value bucket holding one " ^ s.bucket.record
           ^ " per job, keyed by its id.")
            s.bucket.name;
        ];
  }

let files ~root:_ (spec : Spec.t) =
  Result.map (fun t -> [ typescript t; haskell t; rust t ]) (derive spec)
