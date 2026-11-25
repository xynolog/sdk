(* The live queries as the C# SDK names them
   (csharp/sdk/src/Xynolog/LiveQueries.cs): a constant per query, its name
   capitalized ([matchedResources] is [CacheQuery.MatchedResources]). *)

module C = Csharp_syntax

let path = "csharp/sdk/src/Xynolog/Generated/CacheQuery.g.cs"
let constant (q : Table.query) = String.capitalize_ascii q.name

let file (t : Table.t) =
  {
    Output.path;
    text =
      C.text
        {
          header =
            Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog";
          decls =
            [
              C.Type
                {
                  attributes = [];
                  modifiers = [ Internal; Static ];
                  kind = Class;
                  name = "CacheQuery";
                  params = None;
                  base = None;
                  body =
                    Some
                      ( Packed,
                        List.map
                          (fun (q : Table.query) ->
                            C.Field
                              {
                                modifiers = [ Internal; Const ];
                                type_ = C.T "string";
                                name = constant q;
                                value = Some (C.Str q.name);
                              })
                          t.queries );
                };
            ];
        };
  }
