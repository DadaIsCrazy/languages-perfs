let max = int_of_string Sys.argv.(1)

let rec for_step f i j s =
  if i >= j then ()
  else (f i; for_step f (i+s) j s)

let _ =
  let nums = Array.make max false in

  (* 0 and 1 are not prime *)
  Array.set nums 0 true;
  Array.set nums 1 true;

  (* Computing prime numbers *)
  for i = 2 to int_of_float (sqrt (float_of_int max)) do
    if Array.get nums i = false then
      for_step (fun i -> Array.set nums i true) (i*i) max i
  done;

  (* Counting the prime numbers *)
  let total = Array.fold_left (fun acc n -> acc + (if n then 0 else 1)) 0 nums in

  Printf.printf "%d" total
