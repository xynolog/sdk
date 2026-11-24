let matches (terms : Schema_shape.term list) text =
  let valid = ref true in
  let points =
    Uutf.String.fold_utf_8
      (fun points _ -> function
        | `Uchar point -> Uchar.to_int point :: points
        | `Malformed _ ->
            valid := false;
            points)
      [] text
    |> List.rev |> Array.of_list
  in
  let length = Array.length points in
  let holds ranges point =
    List.exists (fun (lo, hi) -> lo <= point && point <= hi) ranges
  in
  (* Whether the points from [position] are of [terms], with [rest] taking
     what is left after them: a step takes as many points as it may and gives
     them back one by one, and a group repeats as often as it may and gives
     repetitions back the same way, until [rest] takes what is left. *)
  let rec series terms position rest =
    match terms with
    | [] -> rest position
    | first :: later -> (
        let next after = series later after rest in
        match first with
        | Schema_shape.Group (either, minimum, maximum) ->
            repeated (either, minimum, maximum) position 0 next
        | Schema_shape.Step (ranges, minimum, maximum) ->
            let limit =
              match maximum with None -> length - position | Some n -> n
            in
            let rec count n =
              if
                n < limit
                && position + n < length
                && holds ranges points.(position + n)
              then count (n + 1)
              else n
            in
            let rec attempt n =
              n >= minimum && (next (position + n) || attempt (n - 1))
            in
            attempt (count 0))
  (* Whether the points from [position] are of the group repeated once more
     than [count] times or more, then of [next]: a repetition past the group's
     minimum takes at least one point. *)
  and repeated ((either, minimum, maximum) as group) position count next =
    Option.fold ~none:true ~some:(fun most -> count < most) maximum
    && List.exists
         (fun alternative ->
           series alternative position (fun after ->
               (count < minimum || after > position)
               && repeated group after (count + 1) next))
         either
    || (count >= minimum && next position)
  in
  !valid && series terms 0 (fun position -> position = length)
