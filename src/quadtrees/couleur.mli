type t
  (* type d'une couleur 16 bits *)

val noir : t
val blanc : t
val rouge : t
val vert : t
val bleu : t
val jaune : t
val cyan : t
val magenta : t
  (* quelques couleurs prédéfinies *)

val rvb : int -> int -> int -> t
  (* [rvb r v b] retourne une couleur dont le niveau de rouge est [r], le
     niveau de vert est [v] et le niveau de bleu est [b]. [r], [v] et [b]
     doivent être compris entre 0 et 255 inclus. *)

val hasard : unit -> t
  (* retourne une couleur aléatoire *)

val inverse : t -> t
  (* retourne l'inverse d'une couleur *)

val remplit : int -> int -> int -> t -> unit
  (* [remplit i j n c] remplit avec la couleur [c] un carré de côté [n] dont le
     coin inférieur gauche est situé en [(i, j)]. *)
