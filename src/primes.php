<?php

$max = $argv[1];

$nums = array_fill(0, $max, false);

// 0 and 1 are not prime
$nums[0] = $nums[1] = true;

// Computing prime numbers
for ($i = 2; $i < sqrt($max); $i++) {
  if ($nums[$i]) continue;
  for ($j = $i*$i; $j < $max; $j+=$i)
    $nums[$j] = true;
}

// Counting prime numbers
$total = 0;
foreach ($nums as $i) {
  $total += $i == false;
}
print($total);

?>