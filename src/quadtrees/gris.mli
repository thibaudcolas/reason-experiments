type t
  (* type d'une couleur en nuance de gris *)

val blanc : t
val noir : t
  (* les couleurs blanches et noires *)

val gris : int -> t
  (* [gris n] est une couleur grise. Plus [n] est petit, plus la couleur est
     fonçée. [n] doit être un nombre compris entre 0 et 255 inclus. *)

val hasard : unit -> t
  (* retourne une couleur aléatoire *)

val inverse : t -> t
  (* retourne l'inverse d'une couleur *)

val remplit : int -> int -> int -> t -> unit
  (* [remplit i j n c] remplit avec la couleur [c] un carré de côté [n] dont le
     coin inférieur gauche est situé en [(i, j)]. *)
