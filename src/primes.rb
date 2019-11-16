max = 1_000_000_000
max_sqrt = 31623

nums = Array.new(max,false)

# 0 and 1 are not prime
nums[0] = nums[1] = true

# Computing prime numbers
(0..max_sqrt).each do |i|
  next if nums[i]
  (i*2 .. max).step(i).each do |j|
    nums[j] = true
  end
end

# Counting prime numbers
total = 0
nums.each do |i|
  total += 1 if i == false
end

print(total)
