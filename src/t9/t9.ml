
type t = { mots : string list ; branches : (int * t) list }

let rec change_assoc i trie = function
    [] -> [i,trie]
  | (x,_)::l when x=i -> (i,trie)::l
  | z::l -> z::(change_assoc i trie l)

let empty = { mots = []; branches = [] }

let rec find l t = 
  match l with
    | [] -> t.mots
    | i::l-> try find l (List.assoc i t.branches) with Not_found -> []

let rec add l s t = 
  match l with
    | [] when List.mem s t.mots-> t
    | [] -> { t with mots = s::t.mots }
    | i::l -> 
	let t' = try List.assoc i t.branches with Not_found -> empty in
	{ t with branches = change_assoc i (add l s t') t.branches }
