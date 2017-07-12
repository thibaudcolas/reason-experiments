open Graphics

let size = 50

let t =
  [|
    [|-1,"";0,"";-1,""|];
    [|7,"pqrs";8,"tuv";9,"wxyz"|];
    [|4,"ghi";5,"jkl";6,"mno"|];
    [|1,"";2,"abc";3,"def"|];
  |]

let draw_key i j =
  match t.(j).(i) with
    | -1,_ -> ()
    | x, s ->
	moveto (i*size + size/2-10) (j*size + size/2);
	draw_string (string_of_int x);
	moveto (i*size + size/2) (j*size + size/2);
	draw_string s

let draw_phone () =
  for i = 0 to 2 do
    for j = 0 to 3 do
      draw_rect (i*size) (j*size) size size;
      draw_key i j
    done
  done

let rec click () =
  let st = wait_next_event [Button_down] in
  let i = st.mouse_x / size in
  let j = st.mouse_y / size in
  set_color black;
  fill_rect (i*size) (j*size) size size;
  let _ = wait_next_event [Button_up] in
  set_color white;
  fill_rect (i*size) (j*size) size size;
  set_color black;
  draw_rect (i*size) (j*size) size size;
  draw_key i j;
  match t.(j).(i) with
    | -1,_ -> click ()
    | x, s ->
	moveto (i*size + size/2 - 10) (j*size + size/2);
	draw_string (string_of_int x);
	x

let show () =
  let s = Printf.sprintf " %dx%d" (3*size) (4*size) in
  open_graph s;
  draw_phone ()
