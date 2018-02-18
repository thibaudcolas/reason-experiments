open Format

let size = 100_000

let ( @ ) l1 l2 = List.rev_append (List.rev l1) l2

module type S = sig
  type t
  val compare : t -> t -> int
end

module Insertion ( E : S ) = struct
  type t = E.t list

  let inserer l x =
    let rec inserer_rec acc l =
      match l with
        | [] -> List.rev (x::acc)
        | y::s ->
          if E.compare x y <= 0 then
            List.rev_append (x::acc) l
          else
            inserer_rec (y::acc) s
    in
    inserer_rec [] l

  let trier l = List.fold_left inserer [] l
end

module QuickSort ( E : S ) = struct
  type t = E.t list

  let partage p l =
    let rec partage_rec ((g, d) as acc) l =
      match l with
        | [] -> acc
        | x::s ->
            if E.compare x p <= 0 then
              partage_rec (x::g, d) s
            else partage_rec (g, x::d) s
    in
    partage_rec ([], []) l

  let rec trier l =
    match l with
      | [] -> []
      | p::s ->
          let (g, d) = partage p s in
          (trier g)@(p :: trier d)
end

module MergeSort ( E : S ) = struct
  type t = E.t list

  let couper l =
    let rec couper_rec (l1, l2) l =
      match l with
        | [] -> (l1, l2)
        | x::l -> couper_rec (x::l2, l1) l
    in
    couper_rec ([], []) l

  let fusion l1 l2 =
    let rec fusion_rec acc l1 l2 =
      match (l1, l2) with
        | [], _ -> List.rev_append acc l2
        | _, [] -> List.rev_append acc l1
        | x::s1, y::s2 ->
            if E.compare x y <= 0 then
              fusion_rec (x::acc) s1 l2
            else
              fusion_rec (y::acc) l1 s2
    in
    fusion_rec [] l1 l2

  let rec trier l =
    match l with
      | [] | [_] -> l
      | _ ->
          let l1,l2 = couper l in
          fusion (trier l1) (trier l2)
end

module T1 = Insertion(struct type t = int let compare = compare end)
module T2 = QuickSort(struct type t = int let compare = compare end)
module T3 = MergeSort(struct type t = int let compare = compare end)


module Time = struct

  open Unix

  let utime f x =
    let u = (times()).tms_utime in
    let y = f x in
    let ut = (times()).tms_utime -. u in
    (y,ut)

  let print f x =
    let (y,ut) = utime f x in
    printf "user time: %2.2f@." ut;
    y

end


let () = Random.self_init ()
let l =
  let l = ref [] in
  for i = 0 to size do
    l := Random.int size::!l
  done;
  !l

let rec is_sorted l =
  match l with
    | [] | [_] -> true
    | x::(y::l as s) -> x<=y && is_sorted s

let () =
  let l' = Time.print T1.trier l in
  assert (is_sorted l');
  let l' = Time.print T2.trier l in
  assert (is_sorted l');
  let l' = Time.print T3.trier l in
  assert (is_sorted l')
