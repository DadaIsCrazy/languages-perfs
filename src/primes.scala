object Primes {
  def main(args: Array[String]) : Unit = {

    val max = args(0).toInt;

    val nums = Array.fill[Boolean](max)(false);

    // 0 and 1 are not primes
    nums(0) = true;
    nums(1) = true;

    // Computing prime numbers
    for (i <- 0 until math.sqrt(max).toInt+1) {
      if (nums(i) == false) {
        for (j <- i*2 until max by i) {
          nums(j) = true
        }
      }
    }

    // Counting prime numbers
    val total = nums.count(_ == false)
    print(total)
  }
}
