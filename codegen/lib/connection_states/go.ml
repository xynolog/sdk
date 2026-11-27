(* The moves of a client's stream as the Go SDK reads them
   (go/connection_states_gen.go): each api.ConnectionState with the states it
   moves to. *)

module G = Go_syntax

let path = "go/connection_states_gen.go"
let state s = G.Name ("api.ConnectionState" ^ Naming.variant s)

let file (t : Table.t) =
  {
    Output.path;
    text =
      G.text
        {
          header =
            G.verbatim
              ("Code generated from " ^ Table.from_
             ^ "; DO NOT EDIT.\n\n\
                Regenerate: make generate (codegen/lib/connection_states/go.ml)"
              );
          package = "xynolog";
          imports = [ [ "github.com/xynolog/sdk/go/api" ] ];
          decls =
            [
              G.Var
                (G.spec
                   ~doc:
                     (G.prose
                        "connectionStateMoves is each state with the states it \
                         moves to, and no other.")
                   "connectionStateMoves"
                   (G.lines
                      ~of_:
                        (G.Map
                           ( G.Named "api.ConnectionState",
                             G.Slice (G.Named "api.ConnectionState") ))
                      (List.map
                         (fun (s, moves) ->
                           G.element ~key:(state s)
                             (G.inline
                                (List.map (fun m -> G.item (state m)) moves)))
                         t)));
            ];
        };
  }
