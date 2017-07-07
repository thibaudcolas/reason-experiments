open Graphics

let width = 600
let height = 600

let max_iterations = 50
let init_step = 2.

let ( + ) = ( +. )
let ( * ) = ( *. )
let ( - ) = ( -. )
let ( / ) = ( /. )

let norme2 (x, y) = x * x + y * y

let rec mandelbrot (a, b) (x, y) i =
  if i = max_iterations || norme2 (x, y) > 4. then i
  else
    let x' = x * x - y * y + a in
    let y' = 2. * x * y + b in
    mandelbrot (a, b) (x', y') (succ i)

(* colorize = linear interpolation between red and blue *)
let colorize n =
  if n = max_iterations then white
  else
    let f = float n / (float max_iterations) in
    rgb  (truncate (f * 255.)) 0 (truncate ((1. - f) * 255.))

let translate v dv s step = step * float v / float s - (step / 2.) + dv

let draw step u v =
  for a = 0 to pred width do
    for b = 0 to pred height do
      let a' = translate a u width step in
      let b' = translate b v height step in
      let i = mandelbrot (a', b') (0., 0.) 0 in
      set_color (colorize i);
      plot a b
    done
  done

let rec loop dx dy step =
  draw step dx dy;
  let st = wait_next_event [Button_down] in
  let dx = translate st.mouse_x dx width step in
  let dy = translate st.mouse_y dy height step in
  let step = step / 2. in
  loop dx dy step

let () =
  open_graph (Printf.sprintf " %dx%d" width height);
  loop 0. 0. init_step
