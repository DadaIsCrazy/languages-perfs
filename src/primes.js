var MAX = 100000000 // (2**27-2)
var MAX_SQRT = 31623

var nums = new Array(MAX).fill(false)

// 0 and 1 are not prime
nums[0] = nums[1] = true

// Computing prime numbers
for (var i = 2; i < MAX_SQRT; i++) {
    if (nums[i]) continue;
    for (var j = i*2; j < MAX; j += i) {
        nums[j] = true
    }
}

// Counting prime numbers
var result = nums.reduce((a,b) => a + (b == false))
console.log("Total: " + result)
