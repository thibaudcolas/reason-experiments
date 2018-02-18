open Printf
open Image

let draw_gray = Image.affiche Gris.remplit
let draw_color = Image.affiche Couleur.remplit

(* Random image *)

let hasard f n =
  let rec make_random n =
    if n = 0 then pixel (f ())
    else
      let n = n - 1 in
      let so = make_random n in
      let se = make_random n in
      let no = make_random n in
      let ne = make_random n in
      quad so se no ne
  in
  if n < 0 then
    invalid_arg "random: should be greater than 0";
  make_random n

(* Damiers *)

let damier c1 c2 n =
  let rec make_damier n =
    match n with
      | 0 -> pixel c1
      | 1 ->
	  let c1 = pixel c1 in
	  let c2 = pixel c2 in
	  quad c1 c2 c2 c1
      | n ->
	  let img = make_damier (n - 1) in
	  quad img img img img
  in
  if n < 0 then invalid_arg "damier: argument n�gatif";
  make_damier n


(* Fractales *)

let fractale c1 c2 n =
  let rec make_fractale n =
    if n = 0 then pixel c1
    else
      let f = make_fractale (n - 1) in
      let c2 = pixel c2 in
      let so = quad f f f c2 in
      let se = quad f f c2 f in
      let no = quad f c2 f f in
      let ne = quad c2 f f f in
      quad so se no ne
  in
  if n < 0 then invalid_arg "fractale: argument n�gatif";
  make_fractale n

(* menu principal *)

type couleur = Couleur | NB
type choix =
  | Hasard of couleur * int
  | Damier of couleur * int
  | Fractale of couleur * int
  | Quitter

let rec choix () =
  printf "Quelle image voulez-vous afficher?\n";
  let i = read_int () in
  if i = 4 then Quitter
  else
    begin
      printf "(c)ouleur au (g)rise?\n";
      let c = match read_line () with "c" -> Couleur | _ -> NB in
      printf "profondeur ?\n";
      let p = read_int () in
      match i with
	| 1 -> Hasard(c, p)
	| 2 -> Damier(c, p)
	| 3 -> Fractale(c, p)
	| _ -> choix ()
    end

let rec menu () =
  printf "1) Hasard\n";
  printf "2) Damier\n";
  printf "3) Fractale\n";
  printf "4) Quitter\n";
  begin
    let i = choix () in
    match i with
      | Hasard(Couleur, n) ->
	  draw_color (hasard Couleur.hasard n)
      | Hasard(NB, n) ->
	  draw_gray (hasard Gris.hasard n)
      | Damier(Couleur, n) ->
	  draw_color (damier Couleur.rouge Couleur.bleu n)
      | Damier(NB, n) ->
	  draw_gray (damier Gris.noir Gris.blanc n)
      | Fractale(Couleur, n) ->
	  draw_color (fractale Couleur.rouge Couleur.bleu n)
      | Fractale(NB, n) ->
	  draw_gray (fractale Gris.noir Gris.blanc n)
      | Quitter -> exit 0
  end;
  menu ()

let () =
  Random.self_init ();
  menu ()
