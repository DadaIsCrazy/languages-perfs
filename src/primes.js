var MAX = Number(process.argv[2])

var nums = new Array(MAX).fill(false)

// 0 and 1 are not prime
nums[0] = nums[1] = true

// Computing prime numbers
for (var i = 2; i <= Math.sqrt(MAX); i++) {
    if (nums[i]) continue;
    for (var j = i*2; j < MAX; j += i) {
        nums[j] = true
    }
}

// Counting prime numbers
var total = nums.reduce((a,b) => a + (b == false), 0)
console.log(""+total)
