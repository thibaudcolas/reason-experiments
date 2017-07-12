
type t = { mots : string list ; branches : (int * t) list }
  
val empty : t

val find : int list -> t -> string list

val add : int list -> string -> t -> t
