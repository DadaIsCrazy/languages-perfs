#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

#define MAX 1e9 // 1 billion
#define MAX_SQRT 31623

int main() {

  bool* nums;
  nums = malloc(MAX * sizeof(*nums));

  // 0 and 1 are not prime
  nums[0] = nums[1] = 1;

  // Computing prime numbers
  for (int i = 2; i < MAX_SQRT; i++) {
    if (nums[i] == 1) continue;
    for (int j = i+i; j < MAX; j += i) {
      nums[j] = 1;
    }
  }

  // Counting the prime numbers
  unsigned int total = 0;
  for (int i = 0; i < MAX; i++)
    total += nums[i] == 0;

  printf("Total: %u\n", total);
}
