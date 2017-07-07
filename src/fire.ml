open Graphics
open Array

type forest_t = Wood | Fire | Ash | Empty

type 'a grille = 'a array array

let create n = make_matrix n n false

let create_forest n = make_matrix n n Empty

let draw grille =
  auto_synchronize false;
  for i = 0 to pred(length grille)  do
    for j = 0 to pred(length grille.(i)) do
      if grille.(i).(j) then set_color green else set_color black;
      fill_rect (i*3) (j*3) 2 2;
    done;
  done;
  synchronize()

let draw_forest foret =
  auto_synchronize false;
  for i = 0 to pred(length foret)  do
    for j = 0 to pred(length foret.(i)) do
      ( match foret.(i).(j) with
	| Wood -> set_color green
	| Ash -> set_color white
	| Empty -> set_color black
	| Fire -> set_color red );
	    
	fill_rect (i*3) (j*3) 2 2; 
    done;
  done;
  synchronize()

let init_center grille = grille.(length grille/2).(length grille.(0)/2) <- true

let init_random p grille =
  Random.self_init();
  for i = 0 to pred(length grille)  do
    for j = 0 to pred(length grille.(i)) do
      match Random.int(100) < p with
	| true -> grille.(i).(j) <- true
	| false -> grille.(i).(j) <- false
    done
  done

let init_forest foret =
  Random.self_init();
  for i = 0 to pred(length foret)  do
    for j = 0 to pred(length foret.(i)) do
      match Random.int(100) < 50 with
	| true -> foret.(i).(j) <- Wood;
	| false -> foret.(i).(j) <- Empty;
    done;
  done;
  foret.(length foret/2).(length foret.(0)/2) <- Fire
  

let up grille x y = if y = pred(length grille.(0)) then grille.(x).(0) else grille.(x).(y+1)

let down grille x y = if y = 0  then grille.(x).(pred(length grille.(0))) else grille.(x).(y-1)

let right grille x y = if x = pred(length grille) then grille.(0).(y) else grille.(x+1).(y)

let left grille x y = if x = 0 then grille.(pred(length grille)).(y) else grille.(x-1).(y)

let up_left grille x y = if x = 0 then up grille (pred(length grille)) y  else up grille (x-1) y

let up_right grille x y = if x = pred(length grille) then up grille 0 y  else up grille (x+1) y

let down_left grille x y = if x = 0 then down grille (pred(length grille)) y  else down grille (x-1) y

let down_right grille x y = if x = pred(length grille) then down grille 0 y  else down grille (x+1) y

let iob b = if b then 1 else 0

let iof f = if f = Fire then 1 else 0

let fredkin prev next i j =
  let sum = iob(up prev i j) + iob(down prev i j) + iob(right prev i j) + iob(left prev i j) in
  next.(i).(j) <- not(sum mod 2 = 0)

let gol prev next i j =
  let sum = iob(up prev i j) + iob(down prev i j) + iob(right prev i j) + iob(left prev i j) + iob(up_left prev i j) + iob (up_right prev i j) + iob(down_left prev i j) + iob(down_right prev i j) in
  next.(i).(j) <- prev.(i).(j) && sum = 2 || sum = 3

let fire prev next i j =
  let sum = iof(up prev i j) + iof(down prev i j) + iof(right prev i j) + iof(left prev i j) + iof(up_left prev i j) + iof (up_right prev i j) + iof(down_left prev i j) + iof(down_right prev i j) in
  match prev.(i).(j) with 
    | Ash -> next.(i).(j) <- Empty;
    | Fire -> next.(i).(j) <- Ash;
    | Wood -> if sum > 0 then next.(i).(j) <- Fire else next.(i).(j) <- Wood;
    | Empty -> next.(i).(j) <- Empty

let react regle prev next = for i = 0 to pred(length prev) do for j = 0 to pred(length prev.(i)) do regle prev next i j done done

let rec loop regle aff prev next =
  aff prev;
  react regle prev next;
  ignore(wait_next_event[Button_down]);
  loop regle aff next prev
 
let run creer aff init regle taille =
  let x = creer taille in
  let y = creer taille in
  init x;
  open_graph (" "^string_of_int(taille*3)^"x"^string_of_int (taille*3));
  loop regle aff x y

let () = run create_forest draw_forest init_forest fire 100
