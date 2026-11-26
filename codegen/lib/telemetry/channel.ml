(* What stands for the bus channel in a span's name, and a name without it
   or open for it. *)

let placeholder = "{channel}"
let without = Text.replace_all ~sub:(":" ^ placeholder) ~by:""

(* A span's name with its channel left for the caller to append:
   bus.emit:{channel} is bus.emit:. *)
let left_open = Text.replace_all ~sub:placeholder ~by:""
