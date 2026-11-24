(* Generated from protocol/specs/src/client/shape-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type shape_accepted = { why : string; schema : string; value : Yojson.Safe.t }

let shape_accepted_json (r : shape_accepted) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("schema", (fun s -> `String s) r.schema);
         Option.Some ("value", Fun.id r.value);
       ])

type frame_refusal_reason = Lacks | Malformed

let frame_refusal_reason_value = function
  | (Lacks : frame_refusal_reason) -> "lacks"
  | (Malformed : frame_refusal_reason) -> "malformed"

let frame_refusal_reason_json v = `String (frame_refusal_reason_value v)

type shape_refused = {
  why : string;
  schema : string;
  value : Yojson.Safe.t;
  refused : bool;
  member : string;
  reason : frame_refusal_reason;
}

let shape_refused_json (r : shape_refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("schema", (fun s -> `String s) r.schema);
         Option.Some ("value", Fun.id r.value);
         Option.Some ("refused", (fun b -> `Bool b) r.refused);
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("reason", frame_refusal_reason_json r.reason);
       ])

type cases_item =
  | Shape_accepted of shape_accepted
  | Shape_refused of shape_refused

let cases_item_json = function
  | (Shape_accepted v : cases_item) -> shape_accepted_json v
  | (Shape_refused v : cases_item) -> shape_refused_json v

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
       "What every SDK's reading of a value finds of it, as a value of a \
        schema Protocol states, as every SDK's reader must. A reader holds a \
        value to what its schema requires of it before it reads it, by the \
        table of each schema's shape the consumer-owned generator derives from \
        the schemas, and finds its first fault as every SDK finds one: a \
        member it lacks (`lacks`), or a value that is not what its schema \
        allows (`malformed`). THE RULE. A value its schema allows is read. One \
        it does not allow is refused for its first fault, named by its way \
        from the value (`member`: the names of the members it is within, and \
        its own, joined by dots; empty for the value itself). What a schema \
        states of an object's members together is held as the table states it: \
        a set of members the object may not carry whole (a `not` of \
        `required`), each member carried that holds null among them; the \
        fewest members it carries (`minProperties`); and what each member's \
        name must be (`propertyNames`), a name that is not being a fault of \
        that member. A member that holds null is carried, and null is a fault \
        of that member when its schema does not allow null. A pattern is read \
        as ECMA-262 reads it, its groups and alternatives among it. A value of \
        a union none of whose variants it is has the first variant's fault. A \
        CASE is a value read as the schema `schema` names, the stem of its \
        file under specs/src: one that is read, or one `refused`: true, with \
        its first fault's `member` and `reason`. Protocol's own validator \
        holds each case: a case that is read is a value the schema allows, and \
        one that is refused a value it does not.";
     cases =
       [
         (Shape_accepted
            ({
               why =
                 "a runner that is somebody else's names where it is reached, \
                  and nothing the launcher runs it from";
               schema = "Runner";
               value = `Assoc [ ("external", `String "db.example.org:5432") ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_accepted
            ({
               why =
                 "a runner the launcher runs names its image and its \
                  resources, and no external";
               schema = "Runner";
               value =
                 `Assoc
                   [
                     ("image", `String "postgres:16"); ("resources", `Assoc []);
                   ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a runner that names its image, its resources and an external \
                  carries a set it may not carry whole: the runner is \
                  malformed";
               schema = "Runner";
               value =
                 `Assoc
                   [
                     ("image", `String "postgres:16");
                     ("resources", `Assoc []);
                     ("external", `String "db.example.org:5432");
                   ];
               refused = true;
               member = "";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a member that holds null is carried: a runner of an image \
                  and resources whose external is null is malformed";
               schema = "Runner";
               value =
                 `Assoc
                   [
                     ("image", `String "postgres:16");
                     ("resources", `Assoc []);
                     ("external", `Null);
                   ];
               refused = true;
               member = "";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a runner of an image alone is none of its variants, and its \
                  fault is its first variant's: it lacks its resources";
               schema = "Runner";
               value = `Assoc [ ("image", `String "postgres:16") ];
               refused = true;
               member = "resources";
               reason = (Lacks : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_accepted
            ({
               why = "a local target names a root and no repository";
               schema = "Target";
               value =
                 `Assoc
                   [ ("kind", `String "local"); ("root", `String "/srv/kb") ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_accepted
            ({
               why = "a codespace target names its repository and no root";
               schema = "Target";
               value =
                 `Assoc
                   [
                     ("kind", `String "codespace"); ("repo", `String "acme/kb");
                   ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a local target that names a repository carries what its \
                  variant may not: it is malformed";
               schema = "Target";
               value =
                 `Assoc
                   [ ("kind", `String "local"); ("repo", `String "acme/kb") ];
               refused = true;
               member = "";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a codespace target that names no repository is none of its \
                  variants, and its fault is its first variant's, whose kind \
                  is local";
               schema = "Target";
               value = `Assoc [ ("kind", `String "codespace") ];
               refused = true;
               member = "kind";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a repository is an owner and a name, with no slash in either";
               schema = "Target";
               value =
                 `Assoc
                   [
                     ("kind", `String "codespace"); ("repo", `String "acme/kb/x");
                   ];
               refused = true;
               member = "repo";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_accepted
            ({
               why =
                 "a name of one letter or digit is of its pattern, whose group \
                  is optional";
               schema = "Metadata";
               value = `Assoc [ ("name", `String "a") ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_accepted
            ({
               why =
                 "a name whose group takes hyphens, letters and digits, and \
                  ends in a letter or digit, is of its pattern";
               schema = "Metadata";
               value = `Assoc [ ("name", `String "kb-one-2") ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a name that ends in a hyphen is of no reading of its pattern";
               schema = "Metadata";
               value = `Assoc [ ("name", `String "kb-") ];
               refused = true;
               member = "name";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a name that begins with a hyphen is of no reading of its \
                  pattern";
               schema = "Metadata";
               value = `Assoc [ ("name", `String "-kb") ];
               refused = true;
               member = "name";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a namespace that holds null is carried, and a namespace is a \
                  string: the namespace is malformed";
               schema = "Metadata";
               value = `Assoc [ ("name", `String "kb"); ("namespace", `Null) ];
               refused = true;
               member = "namespace";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_accepted
            ({
               why = "a request id is a text";
               schema = "RequestId";
               value = `String "r-1";
             }
              : shape_accepted)
           : cases_item);
         (Shape_accepted
            ({
               why = "a request id is an integer";
               schema = "RequestId";
               value = `Int 7;
             }
              : shape_accepted)
           : cases_item);
         (Shape_refused
            ({
               why = "a request id is no number with a fractional part";
               schema = "RequestId";
               value = `Float 1.5;
               refused = true;
               member = "";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why = "a request id is no boolean";
               schema = "RequestId";
               value = `Bool true;
               refused = true;
               member = "";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_accepted
            ({
               why =
                 "an inference document names each provider it reaches by a \
                  provider's name";
               schema = "Inference";
               value =
                 `Assoc
                   [
                     ("apiVersion", `String "xynolog.org/v1alpha1");
                     ("kind", `String "Inference");
                     ("metadata", `Assoc [ ("name", `String "local") ]);
                     ( "spec",
                       `Assoc
                         [
                           ( "providers",
                             `Assoc
                               [
                                 ( "ollama",
                                   `Assoc
                                     [
                                       ( "baseURL",
                                         `String "http://localhost:11434" );
                                     ] );
                               ] );
                           ( "engines",
                             `Assoc
                               [ ("jobs", `Assoc []); ("actors", `Assoc []) ] );
                         ] );
                   ];
             }
              : shape_accepted)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "an inference document reaches at least one provider: its \
                  providers are malformed";
               schema = "Inference";
               value =
                 `Assoc
                   [
                     ("apiVersion", `String "xynolog.org/v1alpha1");
                     ("kind", `String "Inference");
                     ("metadata", `Assoc [ ("name", `String "local") ]);
                     ( "spec",
                       `Assoc
                         [
                           ("providers", `Assoc []);
                           ( "engines",
                             `Assoc
                               [ ("jobs", `Assoc []); ("actors", `Assoc []) ] );
                         ] );
                   ];
               refused = true;
               member = "spec.providers";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why =
                 "a provider is named by a provider's name: a member of \
                  another name is malformed";
               schema = "Inference";
               value =
                 `Assoc
                   [
                     ("apiVersion", `String "xynolog.org/v1alpha1");
                     ("kind", `String "Inference");
                     ("metadata", `Assoc [ ("name", `String "local") ]);
                     ( "spec",
                       `Assoc
                         [
                           ( "providers",
                             `Assoc
                               [ ("ollama", `Assoc []); ("acme", `Assoc []) ] );
                           ( "engines",
                             `Assoc
                               [ ("jobs", `Assoc []); ("actors", `Assoc []) ] );
                         ] );
                   ];
               refused = true;
               member = "spec.providers.acme";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why = "a provider's name is held before what the provider is";
               schema = "Inference";
               value =
                 `Assoc
                   [
                     ("apiVersion", `String "xynolog.org/v1alpha1");
                     ("kind", `String "Inference");
                     ("metadata", `Assoc [ ("name", `String "local") ]);
                     ( "spec",
                       `Assoc
                         [
                           ( "providers",
                             `Assoc
                               [
                                 ("acme", `Assoc []);
                                 ("ollama", `Assoc [ ("baseURL", `String "") ]);
                               ] );
                           ( "engines",
                             `Assoc
                               [ ("jobs", `Assoc []); ("actors", `Assoc []) ] );
                         ] );
                   ];
               refused = true;
               member = "spec.providers.acme";
               reason = (Malformed : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
         (Shape_refused
            ({
               why = "what is lacked is found before a name that is wrong";
               schema = "Inference";
               value =
                 `Assoc
                   [
                     ("apiVersion", `String "xynolog.org/v1alpha1");
                     ("kind", `String "Inference");
                     ("metadata", `Assoc [ ("name", `String "local") ]);
                     ( "spec",
                       `Assoc [ ("providers", `Assoc [ ("acme", `Assoc []) ]) ]
                     );
                   ];
               refused = true;
               member = "spec.engines";
               reason = (Lacks : frame_refusal_reason);
             }
              : shape_refused)
           : cases_item);
       ];
   }
    : t)
