open Graphics

type t = color

let rvb r v b = 
  let bad c = c < 0 || c > 255 in
  if bad r || bad v || bad b then invalid_arg "rvb";
  rgb r v b

let noir = black
let blanc = white
let rouge = red
let vert = green
let bleu = blue
let jaune = yellow
let cyan = cyan
let magenta = magenta

let hasard () = Random.int 256 * 65536 + Random.int 256 * 256 + Random.int 256

let inverse c = 0xFFFFFF - c

let remplit i j n c = 
  set_color c; 
  fill_rect i j n n
