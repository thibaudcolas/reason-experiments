open Graphics

let create n = Array.make_matrix n n false

let draw grille =
  auto_synchronize false;
  for i = 0 to pred(Array.length grille)  do
    for j = 0 to pred(Array.length grille.(i)) do
      if grille.(i).(j) then
	set_color green
else
  set_color black;
fill_rect (i*7) (j*7) 5 5;
    done;
  done;
  synchronize()

let init_center grille =
  grille.(Array.length grille/2).(Array.length grille.(0)/2) <- true

let init_random p grille =
  Random.self_init();
  for i = 0 to pred(Array.length grille)  do
    for j = 0 to pred(Array.length grille.(i)) do
      match Random.int(100) < p with
	| true -> grille.(i).(j) <- true;
	| false -> grille.(i).(j) <- false
    done
  done

let up grille x y = if y = pred(Array.length grille.(0)) then grille.(x).(0) else grille.(x).(y+1)

let down grille x y = if y = 0  then grille.(x).(pred(Array.length grille.(0))) else grille.(x).(y-1)

let right grille x y = if x = pred(Array.length grille) then grille.(0).(y) else grille.(x+1).(y)

let left grille x y = if x = 0 then grille.(pred(Array.length grille)).(y) else grille.(x-1).(y)

let iob b = if b then 1 else 0

let fredkin prev next i j =
  let sum = iob(up prev i j) + iob(down prev i j) + iob(right prev i j) + iob(left prev i j) in
  next.(i).(j) <- not(sum mod 2 = 0)

let react prev next =
  for i = 0 to pred(Array.length prev)  do
    for j = 0 to pred(Array.length prev.(i)) do
      fredkin prev next i j;
    done
  done

let rec loop x y =
    draw x;
    ignore (wait_next_event[Button_down]);
    react x y;
    draw y;
    ignore (wait_next_event[Button_down]);
    loop x y

let () =
    let size = 50 in
    let x = create size in
    let y = create size in
    init_center x;
    init_random 50 x;
    open_graph (" "^string_of_int(size*7)^"x"^string_of_int (size*7));
    loop x y
