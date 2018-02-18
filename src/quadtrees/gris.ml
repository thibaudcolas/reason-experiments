open Graphics

type t = color

let noir = black
let blanc = white

let gris n = 
  if n < 0 || n > 255 then invalid_arg "gris";
  n * 65793 (* 65536 + 256 + 1 *)

let hasard () = gris (Random.int 256)

let inverse c = 0xFFFFFF - c

let remplit i j n c = 
  set_color c; 
  fill_rect i j n n
