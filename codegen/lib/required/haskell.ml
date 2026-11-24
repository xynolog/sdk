(* The table as the Haskell SDK reads it (haskell/sdk/internal/Xynolog/Internal/Required.hs):
   the components' shapes, each bus channel's payload and each HTTP
   operation's reply, as one JSON text in a string literal. Aeson's objects
   keep no order, so an object's members are written as pairs, in the order a
   reader walks them. *)

module H = Haskell_syntax

let path = "haskell/sdk/generated/Xynolog/Internal/Generated/Required.hs"

let text ~shapes ~channels ~http =
  let table entries =
    `Assoc
      (List.map
         (fun (name, shape) -> (name, Shape.to_json ~pairs:true shape))
         entries)
  in
  let json =
    `Assoc
      [
        ("schemas", table shapes);
        ("channels", table channels);
        ("http", table http);
      ]
  in
  H.text
    {
      banner =
        Banner.lines
          ~from_:(Table.authority ^ ", and the bus registry and operations")
          __FILE__;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.Internal.Generated.Required";
      imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
      body =
        [
          H.value "shapesJSON" (T_name "Text")
            (Str (Yojson.Safe.to_string json));
        ];
    }

let file ~shapes ~channels ~http =
  { Output.path; text = text ~shapes ~channels ~http }
