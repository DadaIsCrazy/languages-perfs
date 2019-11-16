package main

import "fmt"

const max = 1000000000 // 1 billion
const max_sqrt = 31623

func main() {

	var nums [max]bool

	// 0 and 1 are not primes
	nums[0] = true
	nums[1] = true

	// Computing primes
	for i := 2; i < max_sqrt; i++ {
		if nums[i] { continue }
		for j := i*2; j < max; j += i {
			nums[j] = true
		}
	}

	// Counting prime numbers
	total := 0
	for i := 0; i < max; i++ {
		if !nums[i] {
			total++
		}
	}
	fmt.Println("Total: ", total)
}
