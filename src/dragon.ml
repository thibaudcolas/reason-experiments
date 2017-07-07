open Graphics

type direction = North | South | East | West
type virage = Left | Right

let change_dir vir dir =
  match vir, dir with
    | Left, North -> West
    | Left, West -> South
    | Left, South -> East
    | Left, East -> North
    | Right, North -> East
    | Right, East  -> South
    | Right, South  -> West
    | Right, West -> North

let move_one_step ((x, y), dir) vir =
  let dirbis = change_dir vir dir in
  match dir with
    | North -> (x, y+1), dirbis
    | South -> (x, y-1), dirbis
    | East -> (x+1, y), dirbis
    | West -> (x-1, y), dirbis

let move ((x, y), dir) vl =
  let (a, b) =
    List.fold_left (fun ((pbis, dbis), acc) e ->
		 let (p, d) = move_one_step (pbis, dbis) e in ((p, d), p::acc))
      (((x, y), dir), [x, y]) vl in List.rev b

let draw_path pl = List.iter (fun e -> plot (fst e) (snd e)) pl

let draw h l ((x, y), dir) vl =
  let taille = " "^(string_of_int h)^"x"^(string_of_int l) in
    open_graph taille;
    let posl = move((x,y), dir) vl in
      draw_path posl

let conj vir = if vir = Left then Right else Left

let unfold vl vlbis = List.append (List.map conj (List.rev vl)) vlbis

let add_fold vl = unfold vl (List.append [ Left; ] vl)

let rec create_dragon nb = if nb > 0 then add_fold (create_dragon (nb-1)) else []

let () =
   let virl = create_dragon 15 in
     draw 500 500 ((250, 250), North) virl;
     ignore(wait_next_event[Button_down])
