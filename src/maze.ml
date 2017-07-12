open Graphics

let () = Random.self_init ()
let n = 30
let gr i = 600 * i / n

let () = 
  open_graph " 600x600";
  for i = 0 to n do
    moveto (gr i) 0; lineto (gr i) 600;
    moveto 0 (gr i); lineto 600 (gr i)
  done

let edges = 
  let l = ref [] in
  for i = 0 to n-1 do 
    for j = 0 to n-1 do
      if i < n-1 then l := ((i, j), (i+1, j)) :: !l;
      if j < n-1 then l := ((i, j), (i, j+1)) :: !l
    done; 
  done;
  Array.of_list !l

let () = Shuffle.knuth edges
let u = Uf.create (n * n)

let () =
  set_color white;
  let f ((i, j), (i', j')) =
    let k = i * n + j in
    let k' = i' * n + j' in
    if Uf.find u k <> Uf.find u k' then begin
      moveto (gr i') (gr (j')) ; 
      lineto (gr (i+1)) (gr (j+1)) ;
      Uf.union u k k';
    end
  in
  Array.iter f edges

let () = ignore (read_key ())