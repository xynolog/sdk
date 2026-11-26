(* What a Haskell worker shares with the TypeScript SDK's
   (typescript/sdk/src/claims.ts): the channels a worker claims a job on and
   commits it on (generated/.../WorkerChannels.hs), and the records a worker
   tells of its jobs and of itself (generated/Xynolog/Worker/Types.hs), each
   read from its declaration there. *)

module H = Haskell_syntax

let source = "typescript/sdk/src/claims.ts"
let ( let* ) = Result.bind
let strip = String.trim
let refused message = [ { Decode.file = source; pointer = ""; message } ]

let strip_affixes ~prefix ~suffix text =
  let text = strip text in
  if String.starts_with ~prefix text && String.ends_with ~suffix text then
    let p = String.length prefix in
    Some (String.sub text p (String.length text - p - String.length suffix))
  else None

(* The quoted names of a literal array: ['a', 'b'] or ['a', 'b',]. *)
let quoted_list text =
  let* inner =
    Option.to_result
      ~none:(refused "worker channels need a literal array")
      (strip_affixes ~prefix:"[" ~suffix:"]" text)
  in
  let entries = String.split_on_char ',' (strip inner) in
  let entries =
    match List.rev entries with
    | last :: rest when strip last = "" -> List.rev rest
    | _ -> entries
  in
  let* names =
    Spec.all
      (List.map
         (fun written ->
           match strip_affixes ~prefix:"'" ~suffix:"'" written with
           | Some value
             when value <> ""
                  && String.for_all
                       (function
                         | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | ':' | '-' ->
                             true
                         | _ -> false)
                       value ->
               Ok value
           | Some _ -> Error (refused "unsupported worker channel name")
           | None -> Error (refused "worker channels need quoted literal names"))
         entries)
  in
  if
    names <> []
    && List.length (List.sort_uniq String.compare names) = List.length names
  then Ok names
  else Error (refused "empty or duplicate worker channel names")

let channels text =
  let* claim =
    Result.map_error refused
      (Marker.between
         "export const JOB_CLAIM_CHANNELS: readonly (keyof EventMap)[] = ["
         "\n];" text)
  in
  let* body =
    let claim = strip claim and prefix = "...replyChannelsFor(" in
    if String.starts_with ~prefix claim then
      Ok (Marker.drop (String.length prefix) claim)
    else Error (refused "unsupported claim channel composition")
  in
  let* requests, extra =
    match Marker.find ")," body with
    | Some i -> Ok (String.sub body 0 i, Marker.drop (i + 2) body)
    | None -> Error (refused "claim channel composition has no reply list")
  in
  let* claim_operations = quoted_list requests in
  let* claim_extras = quoted_list ("[" ^ extra ^ "]") in
  let* commit_operations =
    Result.bind
      (Result.map_error refused
         (Marker.between "const COMMIT_OPERATIONS = "
            " as const satisfies readonly BusOperationKey[];" text))
      quoted_list
  in
  let* composition =
    Result.map_error refused
      (Marker.between
         "export const JOB_COMMIT_CHANNELS: readonly (keyof EventMap)[] =" ";\n"
         text)
  in
  let* () =
    if strip composition = "replyChannelsFor(COMMIT_OPERATIONS)" then Ok ()
    else Error (refused "unsupported commit channel composition")
  in
  let operations names =
    H.Apply
      ( Name "replyChannelsFor",
        [
          List
            (List.map
               (fun n ->
                 H.Apply
                   ( Name "SomeOperation",
                     [ Name (Channels.member n ^ "Operation") ] ))
               names);
        ] )
  in
  let channels = H.T_list (T_name "Text") in
  Ok
    {
      H.banner =
        Banner.lines ~from_:(source ^ " and bus/registry.json") __FILE__;
      extensions = [];
      name = "Xynolog.Internal.Generated.WorkerChannels";
      imports =
        [
          H.import "Data.Text" ~items:[ Plain "Text" ];
          H.import "Xynolog.Bus" ~items:[ Plain "replyChannelsFor" ];
          H.import "Xynolog.Channels";
        ];
      body =
        [
          H.value "jobClaimChannels" channels
            (Infix
               ( operations claim_operations,
                 [
                   ( "++",
                     List
                       (List.map
                          (fun n ->
                            H.Apply
                              (Name "channelName", [ Name (Channels.member n) ]))
                          claim_extras) );
                 ] ));
          H.value "jobCommitChannels" channels (operations commit_operations);
        ];
    }

(* [text] without its block comments. *)
let rec uncomment text =
  match Marker.find "/*" text with
  | None -> Ok text
  | Some i -> (
      let before = String.sub text 0 i in
      let rest = Marker.drop (i + 2) text in
      match Marker.find "*/" rest with
      | None -> Error (refused "unterminated worker interface comment")
      | Some j ->
          Result.map
            (fun after -> before ^ after)
            (uncomment (Marker.drop (j + 2) rest)))

(* [text]'s parts between each [delimiter] outside brackets, each stripped;
   a last that is empty is none. *)
let split delimiter text =
  let found = ref []
  and current = Buffer.create 64
  and depth = ref 0
  and unbalanced = ref false in
  String.iter
    (fun c ->
      if c = delimiter && !depth = 0 then (
        found := strip (Buffer.contents current) :: !found;
        Buffer.clear current)
      else (
        (match c with
        | '{' | '<' | '(' | '[' -> incr depth
        | '}' | '>' | ')' | ']' ->
            if !depth <= 0 then unbalanced := true else decr depth
        | _ -> ());
        Buffer.add_char current c))
    text;
  if !unbalanced || !depth <> 0 then
    Error (refused "unbalanced worker interface type")
  else
    let last = strip (Buffer.contents current) in
    Ok (List.rev (if last = "" then !found else last :: !found))

type field = { key : string; type_ : string; optional : bool }

let fields text =
  let* lines = split ';' text in
  Spec.all
    (List.map
       (fun line ->
         match String.index_opt (strip line) ':' with
         | None -> Error (refused "unsupported worker interface field")
         | Some i ->
             let line = strip line in
             let raw = String.sub line 0 i in
             let optional = String.ends_with ~suffix:"?" raw in
             let key =
               if optional then String.sub raw 0 (String.length raw - 1)
               else raw
             in
             if
               key <> ""
               && String.for_all
                    (function
                      | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' -> true
                      | _ -> false)
                    key
             then Ok { key; type_ = strip (Marker.drop (i + 1) line); optional }
             else Error (refused "unsupported worker interface field"))
       lines)

let first f text =
  if text = "" then text else String.make 1 (f text.[0]) ^ Marker.drop 1 text

let upper = first Char.uppercase_ascii
let lower = first Char.lowercase_ascii

(* The models a worker interface names, each named alike in Haskell. *)
let models = [ "JobId"; "JobType"; "UnitCursor"; "FailureClass" ]

let rec record name members =
  let* () =
    if members = [] then Error (refused "empty worker interface") else Ok ()
  in
  let accessor key = lower name ^ upper key in
  let* typed =
    Spec.all
      (List.map
         (fun f ->
           let* t, nested = field_type (name ^ upper f.key) f.type_ in
           let held = H.Apply (Name (accessor f.key), [ Name "value" ]) in
           let typ, parser, encoder =
             Models.member ~row:"row" ~key:f.key ~held ~nullable:false
               ~mandatory:(not f.optional) t
           in
           Ok ((accessor f.key, typ), parser, encoder, nested))
         members)
  in
  Ok
    (List.concat_map (fun (_, _, _, nested) -> nested) typed
    @ [
        H.record ~constructor:name name
          (List.map (fun (field, _, _, _) -> field) typed)
          ~deriving:[ "Eq"; "Show" ];
        H.instance "FromJSON" (T_name name)
          [
            H.method_ "parseJSON"
              (Dollar
                 ( Apply (Name "withObject", [ Str name ]),
                   Lambda
                     ( "row",
                       Infix
                         ( Name name,
                           List.mapi
                             (fun i (_, parser, _, _) ->
                               ((if i = 0 then "<$>" else "<*>"), parser))
                             typed ) ) ));
          ];
        H.instance "ToJSON" (T_name name)
          [
            ( "toJSON",
              {
                patterns = [ Var "value" ];
                body =
                  Apply
                    ( Name "Object",
                      [
                        Apply
                          ( Name "KM.fromList",
                            [
                              Apply
                                ( Name "concat",
                                  [
                                    List
                                      (List.map
                                         (fun (_, _, encoder, _) -> encoder)
                                         typed);
                                  ] );
                            ] );
                      ] );
              } );
          ];
      ])

and field_type name text =
  let* alternatives = split '|' text in
  match alternatives with
  | [ value; "null" ] ->
      let* t, nested = field_type name value in
      Ok (H.T_apply ("Maybe", [ t ]), nested)
  | [ _ ] -> (
      match
        ( strip_affixes ~prefix:"{" ~suffix:"}" text,
          strip_affixes ~prefix:"" ~suffix:"[]" text,
          strip_affixes ~prefix:"Record<string, " ~suffix:">" text )
      with
      | Some inner, _, _ ->
          let* members = fields inner in
          let* nested = record name members in
          Ok (H.T_name name, nested)
      | None, Some inner, _ ->
          let* t, nested = field_type name inner in
          Ok (H.T_list t, nested)
      | None, None, Some inner ->
          let* t, nested = field_type name inner in
          Ok (H.T_apply ("KM.KeyMap", [ t ]), nested)
      | None, None, None -> (
          match strip text with
          | "string" -> Ok (H.T_name "Text", [])
          | "number" -> Ok (H.T_name "Scientific", [])
          | t when t = Error_codes.Table.bus_name ->
              Ok (H.T_name Error_codes.Haskell.bus_type, [])
          | t when List.mem t models -> Ok (H.T_name t, [])
          | t -> Error (refused ("unsupported worker interface type: " ^ t))))
  | _ -> Error (refused ("unsupported worker interface type: " ^ text))

let types text =
  let* clean = uncomment text in
  let interface ?(extends = "") name =
    Result.bind
      (Result.map_error refused
         (Marker.between
            ("export interface " ^ name ^ extends ^ " {\n")
            "\n}" clean))
      fields
  in
  let* declared =
    Spec.all
      (List.map
         (fun name ->
           Result.map (fun members -> (name, members)) (interface name))
         [ "ClaimRefusal"; "WorkerVitals"; "HeldJobStall"; "JobCheckpoint" ])
  in
  let checkpoint =
    List.map
      (fun f -> { f with optional = true })
      (List.assoc "JobCheckpoint" declared)
  in
  let* failure =
    interface "JobFailure" ~extends:" extends Partial<JobCheckpoint>"
  in
  let* records =
    Spec.all
      (List.map
         (fun (name, members) -> record name members)
         (declared
         @ [ ("JobReached", checkpoint); ("JobFailure", checkpoint @ failure) ]
         ))
  in
  Ok
    {
      H.banner = Banner.lines ~from_:source __FILE__;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.Worker.Types";
      imports =
        [
          H.import "Data.Aeson"
            ~items:
              [
                All "FromJSON";
                All "ToJSON";
                All "Value";
                Plain "withObject";
                Op ".:";
              ];
          H.import "Data.Aeson.KeyMap" ~qualified:"KM";
          H.import "Data.Scientific" ~items:[ Plain "Scientific" ];
          H.import "Data.Text" ~items:[ Plain "Text" ];
          H.import "Xynolog.ErrorCodes"
            ~items:[ Plain Error_codes.Haskell.bus_type ];
          H.import "Xynolog.Internal.Codec"
            ~items:[ Plain "optional"; Plain "optionalPair" ];
          H.import "Xynolog.Types" ~items:(List.map (fun t -> H.Plain t) models);
        ];
      body = List.concat records;
    }

let modules ~root =
  let text = Marker.read ~root source in
  let* channels = channels text in
  let* types = types text in
  Ok [ channels; types ]
