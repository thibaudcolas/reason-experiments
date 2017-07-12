let knuth t =
  for j = Array.length t - 1 downto 1 do
    let k = Random.int (j+1) in
    let v = t.(j) in t.(j) <- t.(k); t.(k) <- v
  done
