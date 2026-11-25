(* The channels a Haskell worker claims a job on and commits it on
   (generated/.../WorkerChannels.hs), each a constant of client/surface.json
   that names them ([Worker_channels]), written with the bus registry's
   operations and channels. *)

module H = Haskell_syntax

let file (spec : Spec.t) =
  let operations names =
    H.Apply
      ( Name "replyChannelsFor",
        [
          List
            (List.map
               (fun n ->
                 H.Apply
                   ( Name "SomeOperation",
                     [ Name (Channels.member n ^ "Operation") ] ))
               names);
        ] )
  in
  let constant (c : Worker_channels.t) =
    H.value c.member
      (H.T_list (T_name "Text"))
      (match c.channels with
      | [] -> operations c.replies_of
      | channels ->
          Infix
            ( operations c.replies_of,
              [
                ( "++",
                  List
                    (List.map
                       (fun n ->
                         H.Apply (Name "channelName", [ Name (Channels.member n) ]))
                       channels) );
              ] ))
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
        H.import "Xynolog.Bus" ~items:[ Plain "replyChannelsFor" ];
        H.import "Xynolog.Channels";
      ];
    body = List.map constant (Worker_channels.all spec);
  }
