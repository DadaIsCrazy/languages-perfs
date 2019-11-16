let max = 1_000_000_000
let max_sqrt = 31623

let rec for_step f i j s =
  if i >= j then ()
  else (f i; for_step f (i+s) j s)

let _ =
  let nums = Array.make max false in

  (* 0 and 1 are not prime *)
  Array.set nums 0 true;
  Array.set nums 1 true;

  (* Computing prime numbers *)
  for i = 2 to max_sqrt do
    if Array.get nums i = false then
      for_step (fun i -> Array.set nums i true) (i*2) max i
  done;

  (* Counting the prime numbers *)
  let total = Array.fold_left (fun acc n -> acc + (if n then 0 else 1)) 0 nums in

  Printf.printf "Total: %d\n" total
