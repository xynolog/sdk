(* The channels a Haskell worker claims a job on and commits it on
   (generated/.../WorkerChannels.hs), each a constant of client/surface.json
   that names them ([Worker_channels]), written with the bus registry's
   channels. *)

module H = Haskell_syntax

let file (spec : Spec.t) =
  let constant (c : Worker_channels.Table.t) =
    H.value c.member (H.T_list (T_name "Text"))
      (List
         (List.map
            (fun n ->
              H.Apply (Name "channelName", [ Name (Channels.member n) ]))
            c.channels))
  in
  {
    H.banner =
      Banner.lines
        ~from_:"protocol/specs/src/client/surface.json and bus/registry.json"
        __FILE__;
    extensions = [];
    name = "Xynolog.Internal.Generated.WorkerChannels";
    imports =
      [
        H.import "Data.Text" ~items:[ Plain "Text" ];
        H.import "Xynolog.Channels";
      ];
    body = List.map constant (Worker_channels.Table.all spec);
  }
