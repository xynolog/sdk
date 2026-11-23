(* Generated from protocol/specs/src/resources/reader-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type read = {
  why : string;
  resource : Yojson.Safe.t;
  primary_representation : Yojson.Safe.t option;
  primary_media_type : string option;
  entity_types : string list;
}

let read_json (r : read) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("resource", Fun.id r.resource);
         Option.map
           (fun v -> ("primaryRepresentation", Fun.id v))
           r.primary_representation;
         Option.map
           (fun v -> ("primaryMediaType", (fun s -> `String s) v))
           r.primary_media_type;
         Option.Some
           ( "entityTypes",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.entity_types
           );
       ])

type reason = Lacks | Malformed

let reason_value = function
  | (Lacks : reason) -> "lacks"
  | (Malformed : reason) -> "malformed"

let reason_json v = `String (reason_value v)

type refused = {
  why : string;
  resource : Yojson.Safe.t;
  refused : bool;
  member : string;
  reason : reason;
}

let refused_json (r : refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("resource", Fun.id r.resource);
         Option.Some ("refused", (fun b -> `Bool b) r.refused);
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("reason", reason_json r.reason);
       ])

type cases_item = Read of read | Refused of refused

let cases_item_json = function
  | (Read v : cases_item) -> read_json v
  | (Refused v : cases_item) -> refused_json v

type t = { comment : string; cases : cases_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "What the readers of a resource's description answer, as every SDK's \
        readers must: `getPrimaryRepresentation`, `getPrimaryMediaType` and \
        `getResourceEntityTypes`, each spelled in its SDK's convention \
        (`getPrimaryRepresentation` is primary_representation). THE RULES. A \
        resource's `representations` is one representation or a list of them. \
        Its primary representation is that one, or the first of the list: the \
        order decides, and nothing a representation says of itself (its `rel`) \
        does. An empty list has no primary representation. A resource that \
        states no `representations`, or states one that is neither one \
        representation (an object that states its `mediaType` as text) nor a \
        list of them, is no ResourceDescriptor, and it is REFUSED: no reader \
        reads it as one with no representation. Its primary media type is the \
        primary representation's `mediaType` as it is stated, with its \
        parameters and in its letter case: nothing is taken from it. Its \
        entity types are its `entityTypes` as they are stated, in their order \
        and with nothing dropped, and an empty list where it states none. A \
        CASE is a `resource`, which is a whole ResourceDescriptor by its \
        schema (specs/src/components/schemas/ResourceDescriptor.json), and \
        what each reader answers of it, or a `resource` the schema does not \
        allow and `refused`: true, which states nothing else but the first \
        fault in it, its `member` and its `reason`: `primaryRepresentation`, \
        the representation whole, and `primaryMediaType`, both of them absent \
        where the resource has no representation; and `entityTypes`, which \
        every case states. HOW IT IS RUN. Every SDK holds each `resource` to \
        what its schema requires (the table the consumer-owned generator \
        writes from the component schemas, whose rules it states) before it \
        decodes it as the type it has of one, and names the first fault it \
        finds as it refuses it: a refused case states that fault, its \
        `member`, the way to it (the names of the members it is within, and \
        its own, joined by dots), and its `reason`, `lacks` (the resource does \
        not carry the member, or the member holds null where it may not) or \
        `malformed` (the member is not what its schema allows: of another \
        kind, a value its enumeration does not list, a text not of its \
        pattern, a number below or above its bounds, or a member a closed \
        object does not name). Of a resource with two faults, every SDK names \
        the same one first: the members a resource lacks, in the order its \
        schema requires them, before a member that is malformed. Every case \
        that is not refused has no fault, and every SDK reads it. Go's and \
        TypeScript's readers, which can be handed a resource no reply brought, \
        refuse one whose `representations` is malformed in its primary \
        representation's and primary media type's readers, as the SDK's own \
        failure whose code is `error`, naming `representations`. TypeScript's \
        runner holds every `resource` here to the schema as well, which must \
        not allow a refused one. Every runner reads every member of a case. \
        Add a case here before changing a reader.";
     cases =
       [
         (Read
            ({
               why =
                 "representations given as a list: the first is the primary \
                  one, and it is given whole";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-list-of-two");
                     ("name", `String "A list of two");
                     ( "representations",
                       `List
                         [
                           `Assoc
                             [
                               ("mediaType", `String "text/markdown");
                               ( "storageUri",
                                 `String "file://notes/a-list-of-two.md" );
                               ("byteSize", `Int 1280);
                               ( "checksum",
                                 `String
                                   "sha256:2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae"
                               );
                               ("language", `String "en");
                               ("rel", `String "original");
                             ];
                           `Assoc
                             [
                               ("mediaType", `String "application/pdf");
                               ( "storageUri",
                                 `String "file://notes/a-list-of-two.pdf" );
                               ("rel", `String "derived");
                             ];
                         ] );
                   ];
               primary_representation =
                 Some
                   (`Assoc
                      [
                        ("mediaType", `String "text/markdown");
                        ("storageUri", `String "file://notes/a-list-of-two.md");
                        ("byteSize", `Int 1280);
                        ( "checksum",
                          `String
                            "sha256:2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae"
                        );
                        ("language", `String "en");
                        ("rel", `String "original");
                      ]);
               primary_media_type = Some "text/markdown";
               entity_types = [];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "the order decides, and not what each says it is: a thumbnail \
                  listed before the original is the primary one";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-thumbnail-first");
                     ("name", `String "A thumbnail listed first");
                     ( "representations",
                       `List
                         [
                           `Assoc
                             [
                               ("mediaType", `String "image/png");
                               ("width", `Int 160);
                               ("height", `Int 120);
                               ("rel", `String "thumbnail");
                             ];
                           `Assoc
                             [
                               ("mediaType", `String "application/pdf");
                               ("rel", `String "original");
                             ];
                         ] );
                   ];
               primary_representation =
                 Some
                   (`Assoc
                      [
                        ("mediaType", `String "image/png");
                        ("width", `Int 160);
                        ("height", `Int 120);
                        ("rel", `String "thumbnail");
                      ]);
               primary_media_type = Some "image/png";
               entity_types = [];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "representations given as one representation, not a list: it \
                  is the primary one";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-one-not-a-list");
                     ("name", `String "One representation, not a list");
                     ( "representations",
                       `Assoc
                         [
                           ("mediaType", `String "image/png");
                           ("storageUri", `String "file://figures/one.png");
                           ("byteSize", `Int 2048);
                         ] );
                   ];
               primary_representation =
                 Some
                   (`Assoc
                      [
                        ("mediaType", `String "image/png");
                        ("storageUri", `String "file://figures/one.png");
                        ("byteSize", `Int 2048);
                      ]);
               primary_media_type = Some "image/png";
               entity_types = [];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "representations given as a list of one, which states its \
                  media type and nothing more";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-list-of-one");
                     ("name", `String "A list of one");
                     ( "representations",
                       `List [ `Assoc [ ("mediaType", `String "text/plain") ] ]
                     );
                   ];
               primary_representation =
                 Some (`Assoc [ ("mediaType", `String "text/plain") ]);
               primary_media_type = Some "text/plain";
               entity_types = [];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "the media type is given as the representation states it: its \
                  parameters and its letter case are not taken from it";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-stated-with-a-charset");
                     ("name", `String "Stated with a charset");
                     ( "representations",
                       `List
                         [
                           `Assoc
                             [
                               ( "mediaType",
                                 `String "Text/Plain; charset=ISO-8859-1" );
                               ("storageUri", `String "file://letters/1998.txt");
                             ];
                         ] );
                   ];
               primary_representation =
                 Some
                   (`Assoc
                      [
                        ("mediaType", `String "Text/Plain; charset=ISO-8859-1");
                        ("storageUri", `String "file://letters/1998.txt");
                      ]);
               primary_media_type = Some "Text/Plain; charset=ISO-8859-1";
               entity_types = [];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "representations given as an empty list: no representation is \
                  the primary one, there is no primary media type, and the \
                  entity types are read all the same";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-empty-list");
                     ("name", `String "An empty list");
                     ("representations", `List []);
                     ("entityTypes", `List [ `String "Concept" ]);
                   ];
               primary_representation = None;
               primary_media_type = None;
               entity_types = [ "Concept" ];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "entity types are given as they are stated, in their order: \
                  they are not sorted";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-three-entity-types");
                     ("name", `String "Three entity types");
                     ( "representations",
                       `List
                         [ `Assoc [ ("mediaType", `String "text/markdown") ] ]
                     );
                     ( "entityTypes",
                       `List
                         [
                           `String "Person";
                           `String "Organization";
                           `String "Location";
                         ] );
                   ];
               primary_representation =
                 Some (`Assoc [ ("mediaType", `String "text/markdown") ]);
               primary_media_type = Some "text/markdown";
               entity_types = [ "Person"; "Organization"; "Location" ];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "an entity type stated twice is given twice: nothing is \
                  dropped from the list";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-entity-type-twice");
                     ("name", `String "An entity type stated twice");
                     ( "representations",
                       `Assoc [ ("mediaType", `String "text/plain") ] );
                     ( "entityTypes",
                       `List
                         [
                           `String "Person"; `String "Author"; `String "Person";
                         ] );
                   ];
               primary_representation =
                 Some (`Assoc [ ("mediaType", `String "text/plain") ]);
               primary_media_type = Some "text/plain";
               entity_types = [ "Person"; "Author"; "Person" ];
             }
              : read)
           : cases_item);
         (Read
            ({
               why = "entity types stated as an empty list are an empty list";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-entity-types-empty");
                     ("name", `String "Entity types stated as an empty list");
                     ( "representations",
                       `List
                         [ `Assoc [ ("mediaType", `String "application/pdf") ] ]
                     );
                     ("entityTypes", `List []);
                   ];
               primary_representation =
                 Some (`Assoc [ ("mediaType", `String "application/pdf") ]);
               primary_media_type = Some "application/pdf";
               entity_types = [];
             }
              : read)
           : cases_item);
         (Read
            ({
               why =
                 "a resource that states only what it must: it has no primary \
                  representation and no primary media type, and its entity \
                  types, which it does not state, are an empty list";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org");
                     ("@id", `String "res-only-what-it-must");
                     ("name", `String "Only what it must");
                     ("representations", `List []);
                   ];
               primary_representation = None;
               primary_media_type = None;
               entity_types = [];
             }
              : read)
           : cases_item);
         (Refused
            ({
               why =
                 "a resource that states no representations is refused: it is \
                  no ResourceDescriptor, and no reader reads it as one with \
                  none";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res-refused");
                     ("name", `String "A resource that is no ResourceDescriptor");
                   ];
               refused = true;
               member = "representations";
               reason = (Lacks : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a resource that states no name is refused: it lacks a member \
                  its schema requires, whatever the member";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res-refused");
                     ( "representations",
                       `List [ `Assoc [ ("mediaType", `String "text/plain") ] ]
                     );
                   ];
               refused = true;
               member = "name";
               reason = (Lacks : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a resource whose representations is neither one \
                  representation nor a list of them is refused";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res-refused");
                     ("name", `String "A resource that is no ResourceDescriptor");
                     ("representations", `String "text/plain");
                   ];
               refused = true;
               member = "representations";
               reason = (Malformed : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a list holding what is not a representation, which states no \
                  media type, is refused";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res-refused");
                     ("name", `String "A resource that is no ResourceDescriptor");
                     ( "representations",
                       `List
                         [
                           `Assoc [ ("mediaType", `String "text/plain") ];
                           `Assoc
                             [
                               ( "storageUri",
                                 `String "file://notes/no-media-type.txt" );
                             ];
                         ] );
                   ];
               refused = true;
               member = "representations.mediaType";
               reason = (Lacks : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a resource with two faults is refused for the first: a \
                  member it lacks is named before one that is malformed, \
                  whatever their names";
               resource =
                 `Assoc
                   [
                     ("@context", `Int 1998);
                     ("@id", `String "res-refused");
                     ( "representations",
                       `List [ `Assoc [ ("mediaType", `String "text/plain") ] ]
                     );
                   ];
               refused = true;
               member = "name";
               reason = (Lacks : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a resource whose id is not of the form its schema states is \
                  refused, naming the id";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res refused");
                     ("name", `String "A resource that is no ResourceDescriptor");
                     ( "representations",
                       `List [ `Assoc [ ("mediaType", `String "text/plain") ] ]
                     );
                   ];
               refused = true;
               member = "@id";
               reason = (Malformed : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a representation whose rel is none its schema lists is \
                  refused, naming the rel within the representations";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res-refused");
                     ("name", `String "A resource that is no ResourceDescriptor");
                     ( "representations",
                       `List
                         [
                           `Assoc
                             [
                               ("mediaType", `String "text/plain");
                               ("rel", `String "sideways");
                             ];
                         ] );
                   ];
               refused = true;
               member = "representations.rel";
               reason = (Malformed : reason);
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a representation whose size is below the least its schema \
                  allows is refused";
               resource =
                 `Assoc
                   [
                     ("@context", `String "https://schema.org/");
                     ("@id", `String "res-refused");
                     ("name", `String "A resource that is no ResourceDescriptor");
                     ( "representations",
                       `Assoc
                         [
                           ("mediaType", `String "text/plain");
                           ("byteSize", `Int (-1));
                         ] );
                   ];
               refused = true;
               member = "representations.byteSize";
               reason = (Malformed : reason);
             }
              : refused)
           : cases_item);
       ];
   }
    : t)
