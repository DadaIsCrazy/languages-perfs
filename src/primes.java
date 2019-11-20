class Primes {

    public static void main(String[] args) {

        int MAX = Integer.parseInt(args[0]);

        boolean[] nums = new boolean[MAX];

        // 0 and 1 are not prime
        nums[0] = nums[1] = true;

        // Computing prime numbers
        for (int i = 2; i <= Math.sqrt(MAX); i++) {
            if (nums[i] == true) continue;
            for (int j = i*2; j < MAX; j += i) {
                nums[j] = true;
            }
        }

        // Counting the prime numbers
        int total = 0;
        for (int i = 0; i < MAX; i++)
            total += nums[i] == false ? 1 : 0;

        System.out.println(total);
    }
}
