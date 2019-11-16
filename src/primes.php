<?php

$max = 1000000000; // 1 billion
$max_sqrt = 31623;

$nums = array_fill(0, $max, false);

// 0 and 1 are not prime
$nums[0] = $nums[1] = true;

for ($i = 2; $i < $max_sqrt; $i++) {
  if ($nums[$i]) continue;
  for ($j = $i*2; $j < $max; $j+=$i)
    $nums[$j] = true;
}

// Counting prime numbers
$total = 0;
foreach ($nums as $i) {
  $total += $i == false;
}
print($total);

?>