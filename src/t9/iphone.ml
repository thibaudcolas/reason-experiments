let keys = function
    'a' | 'b' | 'c' -> 2
  | 'd' | 'e' |'f' -> 3
  | 'g' | 'h' | 'i' -> 4
  | 'j' | 'k' | 'l' -> 5
  | 'm' | 'n' | 'o' -> 6
  | 'p' | 'q' | 'r' | 's' -> 7
  | 't' | 'u' | 'v' -> 8
  | 'w' | 'x' | 'y' | 'z' -> 9
  | _ -> assert false

let intlist_of_string s =
  let n = String.length s in
  let rec list i =
    if i=n then [] else (keys s.[i])::list (i+1)
  in list 0

let dico =
  let cin = open_in "words.txt" in
  let dico = ref T9.empty in
  try
    while true do
      let s = input_line cin in
      try
	dico := T9.add (intlist_of_string s) s !dico
      with Assert_failure _ -> ()
    done;
    !dico
  with End_of_file -> !dico


let () =
  Keyboard.show();
  let l = ref [] in
  while true do
    let i = Keyboard.click () in
    if i = 0 then
      l := []
    else
      begin
	l := !l @ [i];
	let m = T9.find !l dico in
	if m<>[] then
	  begin
	    List.iter (fun s -> Format.printf "%s " s) m;
	    Format.printf "@."
	  end
      end
  done

