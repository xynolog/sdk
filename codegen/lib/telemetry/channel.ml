(* What stands for the bus channel in a span's name, and a name without it. *)

let placeholder = "{channel}"
let without = Text.replace_all ~sub:(":" ^ placeholder) ~by:""
