#!/usr/bin/python3

import sys # argv
import math # sqrt

MAX = int(sys.argv[1])

nums = [False] * MAX

# 0 and 1 are not prime
nums[0] = nums[1] = True

# Computing prime numbers
for i in range(2,int(math.sqrt(MAX))+1):
    if nums[i] == True:
        continue
    for j in range(i*i,MAX,i):
        nums[j] = True;

# Counting prime numbers
total = 0
for i in nums:
    total += i == False
print(total)
