(* What the contracts census counts as a declaration: a name whole, not the
   start of a longer one, and a member only of the type, record or module
   that holds it. *)

open Xynolog_codegen

let case name test = Alcotest.test_case name `Quick test
let check = Alcotest.(check bool)

let whole_names () =
  check "a name, then no more of an identifier" true
    (Contracts.declares "\n  let content_get =" ("\n  let ", "") "content_get");
  check "not the start of a longer name" false
    (Contracts.declares "\n  let content_get_graph =" ("\n  let ", "")
       "content_get");
  check "a longer name, then the name itself" true
    (Contracts.declares "\n  let content_get_graph =\n  let content_get ="
       ("\n  let ", " =") "content_get");
  check "a type's name is not its plural's" false
    (Contracts.declares "pub struct Resources {" ("pub struct ", "") "Resource");
  check "nor at the end of the text" false
    (Contracts.declares "\ntype Annotations" ("\ntype ", "") "Annotation");
  check "the name at the end of the text" true
    (Contracts.declares "\ntype Annotation" ("\ntype ", "") "Annotation");
  check "an empty name is no declaration" false
    (Contracts.declares "\ntype  struct" ("\ntype ", " struct") "")

let gateway =
  "module Gateway = struct\n  let list_streams = (\"GET\", \"/streams\")\nend\n"

let archivist =
  "module Archivist = struct\n  let get_event = (\"GET\", \"/e\")\nend\n"

let members () =
  let archivist_block =
    Contracts.block ~opening:"module Archivist = struct" ~closing:"\nend"
      (gateway ^ archivist)
  in
  check "a member of its module" true
    (Contracts.declares archivist_block ("\n  let ", " =") "get_event");
  check "not of another module, though the file declares it" false
    (Contracts.declares archivist_block ("\n  let ", " =") "list_streams");
  let codes =
    "export type BusCode =\n\
    \  | 'session.auth-failed'\n\
    \  | 'other';\n\
     export type JobCode =\n\
    \  | 'job.lost';\n"
  in
  check "a literal of its union" true
    (Contracts.declares
       (Contracts.block ~opening:"export type BusCode =" ~closing:";" codes)
       ("| '", "'") "session.auth-failed");
  check "not of another union" false
    (Contracts.declares
       (Contracts.block ~opening:"export type JobCode =" ~closing:";" codes)
       ("| '", "'") "session.auth-failed");
  check "a type the text lacks holds nothing" true
    (Contracts.block ~opening:"export type None =" ~closing:";" codes = "")

(* An operationId both the gateway and the archivist name: the archivist's
   module holds it only when it declares it itself. *)
let shared_ids () =
  let gateway_only =
    "module Gateway = struct\n\
    \  let get_health = ()\n\
     end\n\
     module Archivist = struct\n\
    \  let get_event = ()\n\
     end\n"
  in
  check "not the archivist's, though the gateway's holds it" false
    (Contracts.declares
       (Contracts.block ~opening:"module Archivist = struct" ~closing:"\nend"
          gateway_only)
       ("\n  let ", " =") "get_health")

let named line =
  Contracts.member_declared ~keyword:"public " ~stops:[ '('; '{'; '=' ] line

let member_lines () =
  let some = Alcotest.(check (option string)) in
  some "a method" (Some "Claim")
    (named "    public Claims Claim(ClaimOptions options) => new(transport);");
  some "a generic return, and Async" (Some "StatusAsync")
    (named "    public async Task<JobStatusResponse> StatusAsync(JobId id) =>");
  some "a call is no member" None (named "        var status = Status(id);");
  some "a property" (Some "Cache")
    (named "    public Cache<K, V> Cache { get; }");
  check "the name, not a call later on its line" false
    (Contracts.members ~keyword:"public " ~stops:[ '('; '{'; '=' ]
       "    public Claims Claim(ClaimOptions o) => Status(o);" [ "Status" ])

let unclosed () =
  Alcotest.check_raises "a block nothing closes is the census's mistake"
    (Failure "contracts: nothing closes module A = struct") (fun () ->
      ignore
        (Contracts.block ~opening:"module A = struct" ~closing:"\nend"
           "module A = struct"))

let () =
  Alcotest.run "contracts"
    [
      ( "declares",
        [
          case "whole names" whole_names;
          case "members" members;
          case "shared ids" shared_ids;
          case "member lines" member_lines;
          case "unclosed" unclosed;
        ] );
    ]
