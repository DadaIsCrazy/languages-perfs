#!/usr/bin/python3

import sys # argv
import math # sqrt
import numpy as np # perf array and advanced indexing

MAX = int(sys.argv[1])

nums = np.zeros((MAX,), dtype=bool)

# 0 and 1 are not prime
nums[0] = nums[1] = True

# Computing prime numbers
for i in range(2,int(math.sqrt(MAX))+1):
    if nums[i] == True:
        continue
    nums[i*i:MAX:i] = True

# Counting prime numbers
total = MAX - np.count_nonzero(nums)
print(total)
