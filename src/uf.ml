type t = {
  rank : int array;
  parent : int array;
}

let create n =
  { rank = Array.create n 0;
    parent = Array.init n (fun i -> i) }

let rec find t i =
  let p = t.parent.(i) in
  if p = i then
    i
  else begin
    let r = find t p in
    t.parent.(i) <- r;
    r
  end

let union t i j =
  let ri = find t i in
  let rj = find t j in
  if ri <> rj then begin
    if t.rank.(ri) < t.rank.(rj) then
      t.parent.(ri) <- rj
    else begin
      t.parent.(rj) <- ri;
      if t.rank.(ri) = t.rank.(rj) then 
        t.rank.(ri) <- t.rank.(ri) + 1
    end
  end
