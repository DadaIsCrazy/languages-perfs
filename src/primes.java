class Prime {

    static int MAX = 1_000_000_000; // 1 billion
    static int MAX_SQRT = 31623;

    public static void main(String[] args) {

        boolean[] nums = new boolean[MAX];

        // 0 and 1 are not prime
        nums[0] = nums[1] = true;

        // Computing prime numbers
        for (int i = 2; i < MAX_SQRT; i++) {
            if (nums[i] == true) continue;
            for (int j = i+i; j < MAX; j += i) {
                nums[j] = true;
            }
        }

        // Counting the prime numbers
        int total = 0;
        for (int i = 0; i < MAX; i++)
            total += nums[i] == false ? 1 : 0;

        System.out.println("Total: " + total);
    }
}
