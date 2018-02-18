type 'a t = F of 'a | N of 'a t * 'a t * 'a t * 'a t

let pixel c = F c

let quad so se no ne  = N(so, se, no, ne)

let dessine f k img =
  let rec aux i j k = function
    | F c -> f i j k c
    | N(a, b, c, d) -> 
	let k = k / 2 in
	let ik = i + k in
	let jk = j + k in
	aux i j k a;
	aux ik j k b;
	aux i jk k c;
	aux ik jk k d
  in
  aux 0 0 k img

let affiche f img =
  Graphics.open_graph ((Sys.getenv "DISPLAY")^" 512x512");
  Graphics.display_mode false;
  dessine f 512 img;
  Graphics.synchronize ();
  ignore (Graphics.wait_next_event [ Graphics.Key_pressed ]);
  Graphics.close_graph ()
