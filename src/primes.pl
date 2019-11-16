#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

my $MAX = 1_000_000_000; # 1 billion
my $MAX_SQRT = 31623;

my @nums;
$#nums = $MAX;

# 0 and 1 are not prime
$nums[0] = $nums[1] = 1;

# Computing prime numbers
for my $i (2 .. $MAX_SQRT) {
    next if $nums[$i];
    for (my $j = $i+$i; $j < $MAX; $j += $i) {
        $nums[$j] = 1;
    }
}

# Counting prime numbers
my $total = 0;
$total += !$_ for @nums;
say $total
