package main

import (
	"fmt" // Println
	"os"  // Args
	"strconv" // Atoi
	"math" // Sqrt
)

func main() {

	max, _ := strconv.Atoi(os.Args[1])

	nums := make([]bool, max)

	// 0 and 1 are not primes
	nums[0] = true
	nums[1] = true

	// Computing primes
	for i := 2; i < int(math.Sqrt(float64(max)))+1; i++ {
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
	fmt.Println(total)
}
