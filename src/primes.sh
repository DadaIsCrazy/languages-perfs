#!/bin/bash

MAX=100000000;
MAX_SQRT=31623;

nums=()

# 0 and 1 are not primes
nums[0]=1
nums[1]=1

# Computing prime numbers
for (( i=2; i <= $MAX_SQRT; ++i ))
do
    if [ ! ${nums[$i]} ]
    then
        for (( j=i*2; j < MAX; j+=i ))
        do
            nums[$j]=1
        done
    fi
done

# Counting prime numbers
total=0
for (( i=0; i < $MAX; ++i ))
do
    if [ ! ${nums[$i]} ]
    then
        ((total++))
    fi
done

echo "Total: $total"
