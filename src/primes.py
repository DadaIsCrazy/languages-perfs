#!/usr/bin/python3

MAX = 1000000000 # 1 billion
MAX_SQRT = 31623

nums = [False] * MAX

# 0 and 1 are not prime
nums[0] = nums[1] = True

# Computing prime numbers
for i in range(2,MAX_SQRT):
    if nums[i] == True:
        continue
    for j in range(i*2,MAX,i):
        nums[j] = True;

# Counting prime numbers
total = 0
for i in nums:
    total += i == False
print("Total: " + str(total))
