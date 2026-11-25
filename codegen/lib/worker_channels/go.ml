(* The worker's channels as the Go SDK names them (go/worker_channels_gen.go):
   a bus.Channel slice per constant, under its name in Pascal case. *)

module G = Go_syntax

let path = "go/worker_channels_gen.go"

let file (constants : Table.t list) =
  {
    Output.path;
    text =
      G.text
        {
          header =
            G.verbatim
              ("Code generated from protocol/specs/src/" ^ Table.file
             ^ " and bus/registry.json; DO NOT EDIT.\n\n\
                Regenerate: make generate (codegen/lib/worker_channels/go.ml)");
          package = "xynolog";
          imports = [ [ "github.com/xynolog/sdk/go/bus" ] ];
          decls =
            List.map
              (fun (c : Table.t) ->
                let name = String.capitalize_ascii c.member in
                G.Var
                  (G.spec
                     ~doc:(G.prose (name ^ " is " ^ Table.described c ^ "."))
                     name
                     (G.lines ~of_:(G.Slice (G.Named "bus.Channel"))
                        (List.map (fun n -> G.item (G.Quoted n)) c.channels))))
              constants;
        };
  }
