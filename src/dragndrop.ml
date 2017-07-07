open Graphics

let rayon = 10

let move (x, y) (mx, my) (sx, sy) =
  let dx = sx - mx in
  let dy = sy - my in
  (x + dx, y + dy)

let rec drag (x, y) (mx, my) =
  let st = wait_next_event [Mouse_motion; Button_up] in
  if st.button then
    begin
      let (x, y) = move (x, y) (mx, my) (st.mouse_x, st.mouse_y) in
      clear_graph ();
      fill_circle x y rayon;
      drag (x, y) (st.mouse_x, st.mouse_y)
    end
  else
    push (x, y)

and push (x, y) =
  let st = wait_next_event [Button_down] in
  let dx = st.mouse_x - x in
  let dy = st.mouse_y - y in
  if dx * dx + dy * dy <= rayon * rayon then
    begin
      set_color black;
      fill_circle x y rayon;
      drag (x, y) (st.mouse_x, st.mouse_y)
    end
  else
    push (x, y)

let () =
  open_graph " 500x500";
  set_color black;
  fill_circle 100 100 rayon;
  push (100, 100)
