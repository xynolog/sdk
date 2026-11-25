(* The worker's channels as the TypeScript SDK names them
   (typescript/sdk/src/worker-channels.ts): an array of channel names per
   constant, under its name in upper case, each a key of the bus's
   EventMap; and the operations whose replies it names, as a type (the
   operations of [jobCommitChannels] are [JobCommitChannelsOperation]). *)

module T = Typescript_syntax

let path = "typescript/sdk/src/worker-channels.ts"

let file (constants : Table.t list) =
  {
    Output.path;
    text =
      T.text
        {
          banner =
            Banner.typescript_lines
              ~authority:
                [
                  "protocol/specs/src/" ^ Table.file;
                  "protocol/specs/src/bus/registry.json";
                ]
              __FILE__;
          body =
            T.import ~type_only:true [ "EventMap" ] "@xynolog/core"
            :: List.concat_map
                 (fun (c : Table.t) ->
                   [
                   T.Type
                     {
                       about =
                         [
                           T.Doc
                             ("Each operation whose replies "
                             ^ Text.upper_snake c.member ^ " names.");
                         ];
                       export = true;
                       name = String.capitalize_ascii c.member ^ "Operation";
                       params = [];
                       type_ = T.T_union (List.map (fun o -> T.T_str o) c.replies_of);
                     };
                   T.const
                     ~about:[ T.Doc (Table.doc c) ]
                     ~annotation:
                       (T.T_readonly
                          (T.T_array (T.T_paren (T.T_keyof (T.T_name "EventMap")))))
                     (Text.upper_snake c.member)
                     (T.Array
                        (List.map (fun n -> T.element (T.Str n)) c.channels));
                   ])
                 constants;
        };
  }
