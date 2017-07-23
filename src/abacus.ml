open Printf

type tige = { b: int; h: int }
type boulier = tige list

let display_row t =
  if t.h = 1 then printf "-o|" else printf "o-|";
  for i = 1 to t.b do printf "o" done;
  printf "-";
  for i = 3 downto t.b do printf "o" done;
  printf "\n"

let display_abacus b = List.iter display_row b

let rec abacus_of_int = function
  | 0 -> []
  | i ->
      let u = i mod 10 in
      let t =
        if u < 5 then {b = u; h = 0}
        else {b = u - 5; h = 1}
      in
      t::abacus_of_int (i/10)

let int_of_abacus b =
  List.fold_right (fun {b=b; h=h} acc -> (b + h * 5) + (acc * 10)) b 0

let add_row ret {b=b1; h=h1} {b=b2; h=h2} =
  let b = b1 + b2 + ret in
  let h3 = b / 5 + h1 + h2  in
  {b = b mod 5 ; h = h3 mod 2}, h3 / 2

let addition =
  let rec addition ret b1 b2 =
    match (b1, b2) with
      | ([], _) when ret=0 -> b2

      | ([], []) -> abacus_of_int ret

      | ([], n::l) ->
          let n, ret = add_row ret {b=0; h=0} n in
          n::(addition ret [] l)

      | (n1::l1, n2::l2) ->
          let n, ret = add_row ret n1 n2 in
          n::(addition ret l1 l2)

      | (l , []) ->
          addition ret [] l
  in
  addition 0

let list_of_abacuses l = List.map abacus_of_int l

let add_list l =
  int_of_abacus (List.fold_left addition (abacus_of_int 0) l)

let () =
  let b1 = abacus_of_int 6 in
  assert (6 = int_of_abacus b1);
  display_abacus b1;
  let b2 = abacus_of_int 18 in
  assert (18 = int_of_abacus b2);
  display_abacus b2;
  let x1 = add_list [b1; b2] in
  let b = addition b1 b2 in
  assert (x1 = int_of_abacus b)
