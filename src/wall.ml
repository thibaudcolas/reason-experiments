module type HashType = sig
  type t
  val hash : t -> int
  val equal : t -> t -> bool
end

module type S = sig
  type key
  type 'a t
  val create : unit -> 'a t
  val cardinal : 'a t -> int
  val add : key -> 'a -> 'a t -> unit
  val find : key -> 'a t -> 'a
  val remove : key -> 'a t -> unit
end

module  Make (X : HashType) : S with type key = X.t = struct
  type key = X.t
  type 'a t = {
    mutable size : int;
    buckets : (key * 'a) list array;
  }

  let array_length = 5003

  let create () = { size = 0; buckets = Array.create array_length [] }

  let cardinal h = h.size

  let find x h =
    let i = (X.hash x) mod array_length in
    let rec lookup = function
      | [] -> raise Not_found
      | (k, v) :: _ when X.equal x k -> v
      | _ :: b -> lookup b
    in
    lookup h.buckets.(i)

  let mem_bucket x = List.exists (fun (y, _) -> X.equal x y)

  let add x v h =
    let i = (X.hash x) mod array_length in
    let b = h.buckets.(i) in
    if not (mem_bucket x b) then begin
      h.size <- h.size + 1;
      h.buckets.(i) <- (x, v) :: b
    end

  let remove x h =
    let i = (X.hash x) mod array_length in
    let b = h.buckets.(i) in
    if mem_bucket x b then begin
      h.size <- h.size - 1;
      h.buckets.(i) <- List.filter (fun (y, _) -> not (X.equal y x)) b
    end
end

module P = struct
  type t = int * int
  let hash = Hashtbl.hash
  let equal = (=)
end

module H = Make(P)

let width = 32
let height = 10

let add2 r = (r lsl 2) lor 0b10
let add3 r = (r lsl 3) lor 0b100

let rec rows n =
  if n <= 1 then []
  else if n = 2 || n = 3 then [0]
  else
    List.map add2 (rows (n-2)) @ List.map add3 (rows (n-3))

let rows = rows 32

let sum f l = List.fold_left (fun acc x -> Int64.add (f x) acc) 0L l

(* version 1 *)

let rec w (r, h) =
  if h  = 1 then 1L
  else sum (fun r' -> if r land r' = 0 then w (r', h - 1) else 0L) rows

(* version 2 *)

let table = H.create ()

let rec w (r, h) =
  if h  = 1 then 1L
  else sum (fun r' -> if r land r' = 0 then memo_w (r', h - 1) else 0L) rows

and memo_w (r, h) =
  try  H.find (r, h) table
  with Not_found -> let v = w (r, h) in H.add (r,h) v table; v


let memo f =
  let table = H.create () in
  fun x->
    try  H.find x table
    with Not_found -> let v = f x in H.add x v table; v

let rec w (r, h) =
  if h  = 1 then 1L
  else sum (fun r' -> if r land r' = 0 then memo_w (r', h - 1) else 0L) rows
and memo_w x = memo w x

(* version 3 *)

let memo ff =
  let h = H.create () in
  let rec f x =
    try H.find x h
    with Not_found -> let v = ff f x in H.add x v h; v
  in f

let w =
  memo
    (fun w (r, h) ->
       if h  = 1 then 1L
       else sum (fun r' -> if r land r' = 0 then w (r', h - 1) else 0L) rows)

let sol = sum (fun r -> w (r, height)) rows
let () = Format.printf "%Ld@." sol
