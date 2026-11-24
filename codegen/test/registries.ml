(* The media types, telemetry, OAuth clients, sign-in and locales groups, and
   the job storage group's reading of a mark job's motivations, each refuse a
   table that cannot be meant, naming the place. Each case changes one thing
   of a table every rule holds; the first case of each is that table. *)

open Xynolog_codegen

let case name test = Alcotest.test_case name `Quick test

let contains ~sub text =
  let n = String.length sub in
  let rec at i =
    i + n <= String.length text && (String.sub text i n = sub || at (i + 1))
  in
  at 0

let refuses pointer saying = function
  | Ok _ -> Alcotest.failf "accepted what has a fault at %s" pointer
  | Error errors ->
      if
        not
          (List.exists
             (fun (e : Decode.error) ->
               e.pointer = pointer && contains ~sub:saying e.message)
             errors)
      then
        Alcotest.failf "refused, but not at %s saying %S: %s" pointer saying
          (String.concat "; " (List.map Decode.error_to_string errors))

let accepts = function
  | Ok _ -> ()
  | Error errors ->
      Alcotest.failf "refused: %s"
        (String.concat "; " (List.map Decode.error_to_string errors))

module M = Tables.Media_types_registry

let row ?(media_type = "text/markdown") ?(extension = ".md")
    ?(label = "Markdown") ?(render = "text") () : M.media_types_item =
  {
    media_type;
    extension;
    label;
    render;
    anchoring = "text-selector";
    text_source = "decode";
    authorable = true;
    uploadable = true;
    generatable = true;
  }

let registry ?(render = [ "text"; "none" ])
    ?(rows =
      [
        row (); row ~media_type:"text/plain" ~extension:".txt" ~label:"Text" ();
      ]) ?(aliases = [ (".markdown", ".md") ]) () : M.t =
  {
    comment = "c";
    render;
    anchoring = [ "text-selector"; "none" ];
    text_source = [ "decode"; "none" ];
    extension_aliases = aliases;
    media_types = rows;
  }

let admitted = [ "text/markdown"; "text/plain" ]
let media ?(admitted = admitted) t = Media_types.derive t admitted

let media_types =
  [
    case "a registry every rule holds" (fun () -> accepts (media (registry ())));
    case "a type stated twice" (fun () ->
        refuses "/mediaTypes/2/mediaType" "states already"
          (media
             (registry
                ~rows:
                  [
                    row ();
                    row ~media_type:"text/plain" ~extension:".txt" ();
                    row ();
                  ]
                ())));
    case "a type that is not a base media type" (fun () ->
        List.iter
          (fun media_type ->
            refuses "/mediaTypes/0/mediaType" "not a base media type"
              (media
                 ~admitted:[ media_type; "text/plain" ]
                 (registry
                    ~rows:
                      [
                        row ~media_type ();
                        row ~media_type:"text/plain" ~extension:".txt" ();
                      ]
                    ())))
          [ "Text/Markdown"; "text/markdown; charset=utf-8" ]);
    case "a row the enum does not admit, and an admitted type with no row"
      (fun () ->
        refuses "/mediaTypes" "does not admit"
          (media ~admitted:[ "text/markdown" ] (registry ()));
        refuses "/mediaTypes" "has no row for text/x-unheard-of"
          (media ~admitted:("text/x-unheard-of" :: admitted) (registry ())));
    case "a capability outside its vocabulary" (fun () ->
        refuses "/mediaTypes/0/render" "hologram"
          (media
             (registry
                ~rows:
                  [
                    row ~render:"hologram" ();
                    row ~media_type:"text/plain" ~extension:".txt" ();
                  ]
                ())));
    case "an extension that is not a dot and a lower-case name" (fun () ->
        List.iter
          (fun extension ->
            refuses "/mediaTypes/0/extension" "not a dot"
              (media
                 (registry
                    ~rows:
                      [
                        row ~extension ();
                        row ~media_type:"text/plain" ~extension:".txt" ();
                      ]
                    ())))
          [ "md"; ".MD"; "."; ".tar.gz" ]);
    case "a row with no label" (fun () ->
        refuses "/mediaTypes/0/label" "is empty"
          (media
             (registry
                ~rows:
                  [
                    row ~label:"" ();
                    row ~media_type:"text/plain" ~extension:".txt" ();
                  ]
                ())));
    case "a vocabulary that states a word twice" (fun () ->
        refuses "/render/2" "states already"
          (media (registry ~render:[ "text"; "none"; "text" ] ())));
    case "an alias of an extension no row states, and one that is a row's own"
      (fun () ->
        refuses "/extensionAliases/.mdown" "no row states"
          (media (registry ~aliases:[ (".mdown", ".mdx") ] ()));
        refuses "/extensionAliases/.txt" "a row's own extension"
          (media (registry ~aliases:[ (".txt", ".md") ] ())));
  ]

module Tm = Tables.Sdk_telemetry_telemetry

let attribute ?only key : Tm.service_telemetry_telemetry_attributes_item =
  { key; only; values = None }

let span ?(name = "bus.emit:{channel}") ?(kind = Tm.Producer)
    ?(attributes =
      [ attribute "bus.channel"; attribute ~only:"scoped" "bus.scope" ]) () :
    Tm.spans_item =
  { name; transport = Bus; kind; meaning = "A frame sent."; attributes }

let metric ?(instrument = Tm.Counter) () : Tm.metrics_item =
  {
    name = "xynolog.bus.sent";
    transport = Bus;
    instrument;
    meaning = "Emits sent.";
    attributes = [ { key = "bus.channel"; only = None; values = None } ];
  }

let telemetry ?(spans = [ span () ]) ?(metrics = [ metric () ]) () =
  Telemetry.derive { comment = "c"; spans; metrics }

let telemetries =
  [
    case "a table every rule holds" (fun () -> accepts (telemetry ()));
    case "a metric of an instrument but a counter" (fun () ->
        refuses "/metrics/0/instrument" "none of"
          (telemetry ~metrics:[ metric ~instrument:Tm.Gauge () ] ()));
    case "a span name with a placeholder but the channel" (fun () ->
        refuses "/spans/0/name" "placeholder"
          (telemetry ~spans:[ span ~name:"bus.emit:{thread}" () ] ()));
    case "an attribute stated twice" (fun () ->
        refuses "/spans/0/attributes/1/key" "states already"
          (telemetry
             ~spans:
               [
                 span
                   ~attributes:
                     [ attribute "bus.channel"; attribute "bus.channel" ]
                   ();
               ]
             ()));
    case "two spans that are one Go identifier" (fun () ->
        refuses "" "Go identifier spanContentGetGraph"
          (telemetry
             ~spans:
               [
                 span ~name:"content.get_graph" ();
                 span ~name:"content.get.graph" ();
               ]
             ()));
  ]

module O = Tables.Session_oauth

let oauth names =
  Oauth_clients.derive
    {
      comment = "c";
      clients =
        List.map
          (fun name : O.clients_item ->
            { name; id = "xynolog-" ^ name; docs = "D." })
          names;
      scopes = { value = "openid"; docs = "D." };
    }

let oauth_clients =
  [
    case "clients every rule holds" (fun () ->
        accepts (oauth [ "browser"; "script" ]));
    case "a client not named in lowercase letters" (fun () ->
        refuses "/clients/1/name" "not lowercase letters"
          (oauth [ "browser"; "Script2" ]));
    case "a client named twice" (fun () ->
        refuses "/clients/1/name" "states already"
          (oauth [ "browser"; "browser" ]));
  ]

let owner_only ?(directory = "0700") ?(access = "D:PAI(A;OICI;FA;;;{owner})") ()
    =
  Sign_in.Owner_only.derive
    {
      comment = "c";
      directory_mode = { value = directory; docs = "D." };
      file_mode = { value = "0600"; docs = "D." };
      directory_access_list = { value = access; docs = "With `{owner}`." };
      file_access_list = { value = "D:PAI(A;;FA;;;{owner})"; docs = "F." };
    }

let flat json =
  match
    Decode.run ~file:"SignIn.json" (Yojson.Safe.from_string json) Schema.decode
  with
  | Error e ->
      Alcotest.failf "the fixture is no schema: %s" (Decode.error_to_string e)
  | Ok (schema, _) -> Sign_in.Flat.read ~file:"SignIn.json" schema

let entry ?(token = {|{"type":"string","description":"T."}|})
    ?(required = {|["token"]|}) () =
  Printf.sprintf
    {|{"title":"SignIn","type":"object","description":"An entry.","properties":{"token":%s,"obtainedAt":{"type":"string","format":"date-time","description":"When."}},"required":%s}|}
    token required

let sign_in =
  [
    case "an owner-only policy every rule holds" (fun () ->
        match owner_only () with
        | Ok o ->
            Alcotest.(check string)
              "the owner's place, by its argument" "With `owner`."
              o.directory_access_list.docs
        | Error _ -> Alcotest.fail "refused");
    case "a mode that is not four octal digits" (fun () ->
        List.iter
          (fun directory ->
            refuses "/directoryMode/value" "four octal digits"
              (owner_only ~directory ()))
          [ "700"; "0800"; "07000" ]);
    case "an access list that names the owner's place twice" (fun () ->
        refuses "/directoryAccessList/value" "2 times"
          (owner_only ~access:"D:(A;;FA;;;{owner})(A;;FA;;;{owner})" ()));
    case "an entry every rule holds" (fun () -> accepts (flat (entry ())));
    case "a property that is not a string" (fun () ->
        refuses "/properties/token/type" "is not string"
          (flat (entry ~token:{|{"type":"integer","description":"T."}|} ())));
    case "a property with a keyword a flat schema has not" (fun () ->
        refuses "/properties/token" "uses pattern"
          (flat
             (entry
                ~token:{|{"type":"string","pattern":"^a$","description":"T."}|}
                ())));
    case "a requirement that is no property" (fun () ->
        refuses "/required/1" "not a property"
          (flat (entry ~required:{|["token","issuer"]|} ())));
  ]

let locale ?(native_name = "Deutsch") ?(english_name = "German") code :
    Tables.Locales_registry.locales_item =
  { code; native_name; english_name }

let locales rows = Locales.derive { comment = "c"; locales = rows }

let locale_registry =
  [
    case "a registry every rule holds" (fun () ->
        accepts (locales [ locale "de"; locale "fil" ]));
    case "a language stated twice" (fun () ->
        refuses "/locales/1/code" "states already"
          (locales [ locale "de"; locale "de" ]));
    case "a code that is not a lower-case language code" (fun () ->
        List.iter
          (fun code ->
            refuses "/locales/0/code" "not a lower-case language code"
              (locales [ locale code ]))
          [ "DE"; "d"; "deut"; "de-AT" ]);
    case "a language with no native name, and one with no English name"
      (fun () ->
        refuses "/locales/0/nativeName" "is empty"
          (locales [ locale ~native_name:"" "de" ]);
        refuses "/locales/0/englishName" "is empty"
          (locales [ locale ~english_name:"" "de" ]));
    case "a registry with no languages" (fun () ->
        refuses "/locales" "states no languages" (locales []));
  ]

let schema file json =
  match Decode.run ~file (Yojson.Safe.from_string json) Schema.decode with
  | Error e ->
      Alcotest.failf "the fixture is no schema: %s" (Decode.error_to_string e)
  | Ok (schema, _) -> (file, schema)

let mark_branch ?(required = {|["motivation"]|}) ?(words = {|["highlighting"]|})
    name =
  schema
    ("components/schemas/" ^ name ^ ".json")
    (Printf.sprintf
       {|{"type":"object","properties":{"motivation":{"type":"string","enum":%s}},"required":%s}|}
       words required)

let mark_schemas
    ?(params =
      {|{"oneOf":[{"$ref":"./HighlightingJobParams.json"},{"$ref":"./TaggingJobParams.json"}],"discriminator":{"propertyName":"motivation","mapping":{"highlighting":"./HighlightingJobParams.json","tagging":"./TaggingJobParams.json"}}}|})
    ?(highlighting = mark_branch "HighlightingJobParams") () =
  [
    schema "components/schemas/MarkJobParams.json" params;
    schema "components/schemas/Motivation.json"
      {|{"type":"string","enum":["highlighting","tagging"]}|};
    highlighting;
    mark_branch ~words:{|["tagging"]|} "TaggingJobParams";
  ]

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])
let marks = Job_storage.branch_motivations ids

let mark_motivations =
  [
    case "each branch's component and motivation, in the branches' order"
      (fun () ->
        Alcotest.(check (list (pair string string)))
          "motivations"
          [
            ("HighlightingJobParams", "highlighting");
            ("TaggingJobParams", "tagging");
          ]
          (match marks (mark_schemas ()) with
          | Ok words -> words
          | Error errors ->
              Alcotest.failf "refused: %s"
                (String.concat "; " (List.map Decode.error_to_string errors))));
    case "a branch whose motivation is not required" (fun () ->
        refuses "/oneOf/0" "required motivation"
          (marks
             (mark_schemas
                ~highlighting:
                  (mark_branch ~required:{|["other"]|} "HighlightingJobParams")
                ())));
    case "a branch of more than one motivation, and of one Motivation lacks"
      (fun () ->
        refuses "/oneOf/0" "required motivation"
          (marks
             (mark_schemas
                ~highlighting:
                  (mark_branch ~words:{|["highlighting","tagging"]|}
                     "HighlightingJobParams")
                ()));
        refuses "/oneOf/0" "required motivation"
          (marks
             (mark_schemas
                ~highlighting:
                  (mark_branch ~words:{|["linking"]|} "HighlightingJobParams")
                ())));
    case "a mapping that names another branch for a word" (fun () ->
        refuses "/oneOf/0" "mapped to it"
          (marks
             (mark_schemas
                ~params:
                  {|{"oneOf":[{"$ref":"./HighlightingJobParams.json"},{"$ref":"./TaggingJobParams.json"}],"discriminator":{"propertyName":"motivation","mapping":{"highlighting":"./TaggingJobParams.json","tagging":"./TaggingJobParams.json"}}}|}
                ())));
    case "a mapping of an extra word" (fun () ->
        refuses "/discriminator/mapping" "does not name each branch once"
          (marks
             (mark_schemas
                ~params:
                  {|{"oneOf":[{"$ref":"./HighlightingJobParams.json"},{"$ref":"./TaggingJobParams.json"}],"discriminator":{"propertyName":"motivation","mapping":{"highlighting":"./HighlightingJobParams.json","tagging":"./TaggingJobParams.json","linking":"./TaggingJobParams.json"}}}|}
                ())));
    case "a branch that is no plain $ref" (fun () ->
        refuses "/oneOf/0" "is no plain $ref"
          (marks
             (mark_schemas
                ~params:
                  {|{"oneOf":[{"$ref":"./HighlightingJobParams.json","description":"d"},{"$ref":"./TaggingJobParams.json"}],"discriminator":{"propertyName":"motivation","mapping":{"highlighting":"./HighlightingJobParams.json","tagging":"./TaggingJobParams.json"}}}|}
                ())));
    case "branches told apart by another property" (fun () ->
        refuses "" "told apart by a mapping of its motivation"
          (marks
             (mark_schemas
                ~params:
                  {|{"oneOf":[{"$ref":"./HighlightingJobParams.json"},{"$ref":"./TaggingJobParams.json"}],"discriminator":{"propertyName":"kind","mapping":{"highlighting":"./HighlightingJobParams.json","tagging":"./TaggingJobParams.json"}}}|}
                ())));
  ]

let () =
  Alcotest.run "registries"
    [
      ("mark motivations", mark_motivations);
      ("locales", locale_registry);
      ("media types", media_types);
      ("telemetry", telemetries);
      ("oauth clients", oauth_clients);
      ("sign-in", sign_in);
    ]
