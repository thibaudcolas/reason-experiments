open Graphics

let width = 15
let height = 10
let diameter = 60
let radius = diameter / 2

type color = Red | Yellow | Blue | Empty

let random_color () =
  match Random.int 3 with
    | 0 -> Red
    | 1 -> Yellow
    | 2 -> Blue
    | _ -> assert false

let grid =
  Array.init
    width
    (fun _ -> Array.init height (fun _ -> random_color ()))

let color_of_color c =
  match c with
    | Red -> red
    | Yellow -> yellow
    | Blue -> blue
    | Empty -> black


let draw () =
  for i = 0 to width - 1 do
    for j = 0 to height - 1 do
      let x = i * diameter + radius in
      let y = j * diameter + radius in
      set_color (color_of_color grid.(i).(j));
      fill_circle x y radius
    done
  done

let color i j =
  if 0 <= i && i < width && 0 <= j && j < height then
    grid.(i).(j)
  else
    Empty

let pack_grid keep t =
  let n = Array.length t in
  let swap a b =
    let tmp = t.(a) in
    t.(a) <- t.(b);
    t.(b) <- tmp
  in
  let d = ref 0 in
  for i = 0 to n - 1 do
    if keep t.(i) then
      begin
        swap i !d;
        d := !d + 1
      end
  done

let pack () =
  for i = 0 to width - 1 do
    pack_grid (fun c -> c<>Empty) grid.(i)
  done;
  pack_grid (fun t -> t.(0) <> Empty) grid


let rec erase_area c i j =
    if color i j = c then
      begin
        grid.(i).(j) <- Empty;
        erase_area c (i-1) j;
        erase_area c (i+1) j;
        erase_area c i (j-1);
        erase_area c i (j+1)
      end

let at_least_two_circles c i j =
  color (i - 1) j = c ||
  color (i + 1) j = c ||
  color i (j - 1) = c ||
  color i (j + 1) = c

let rec play () =
  let st = wait_next_event [Button_down] in
  let dx = st.mouse_x mod diameter - radius in
  let dy = st.mouse_y mod diameter - radius in
  if dx * dx + dy * dy <= radius * radius then
    begin
      let i = st.mouse_x / diameter in
      let j = st.mouse_y / diameter in
      let c = color i j in
      if c <> Empty && at_least_two_circles c i j then
        begin
          erase_area c i j;
          pack ();
          draw ()
        end
    end;
  play ()

let ()  =
  let l = width * diameter in
  let h = height * diameter in
  let s = Printf.sprintf " %dx%d" l h in
  open_graph s;
  set_color black;
  fill_rect 0 0 l h ;
  draw();
  play()
