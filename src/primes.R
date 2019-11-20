#!/usr/bin/env Rscript
# WARNING: R is 1-indexed
printf <- function(...) cat(sprintf(...))
MAX = as.integer(commandArgs(trailingOnly = TRUE)[1])

nums = vector(length = MAX)

# 0 and 1 are not prime, 
nums[c(1,2)] = TRUE

# Computing prime numbers
for (i in 3:floor(sqrt(MAX)+1)) {
  if (nums[i] == TRUE) {
    next
  }
  nums[seq(i*2-1, MAX, i-1)] = TRUE
}

total = MAX - sum(nums)
printf("%d\n", total)

