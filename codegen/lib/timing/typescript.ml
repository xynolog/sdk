(* The timing as the TypeScript SDK reads it (typescript/core/src): a constant
   per entry under its name in upper case. *)

module T = Typescript_syntax

let path = "typescript/core/src/client-timing.ts"
let name (e : Table.entry) = Text.upper_snake e.name

let constant (e : Table.entry) =
  let name = name e and about = [ T.Doc e.docs ] in
  match e.value with
  | Duration n | Count n -> T.const ~about name (Int n)
  | Budget { attempts; initial_delay_ms; max_delay_ms } ->
      T.const ~about name ~annotation:(T_name "RetryBudget")
        (Object
           {
             layout = Inline;
             entries =
               [
                 T.entry (Ident "attempts") (Int attempts);
                 T.entry (Ident "initialDelayMs") (Int initial_delay_ms);
                 T.entry (Ident "maxDelayMs") (Int max_delay_ms);
               ];
           })

let text (t : Table.t) =
  T.text
    {
      banner =
        Banner.typescript_lines
          ~authority:[ "protocol/specs/src/client/timing.json" ]
          __FILE__;
      body =
        T.import ~type_only:true [ "RetryBudget" ] "./retry"
        :: List.map constant t;
    }

let file t = { Output.path; text = text t }
