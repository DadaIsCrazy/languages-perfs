use std::env;

fn main() {

    let max : usize = env::args().nth(1).unwrap().parse().unwrap();

    let mut nums = vec![false; max];

    // 0 and 1 are not primes
    nums[0] = true;
    nums[1] = true;

    // Computing prime numbers
    for i in 2..(1+(max as f64).sqrt() as usize) {
        if nums[i] { continue; }
        for j in (i*2..max).step_by(i) {
            nums[j] = true;
        }
    }

    // Couting the prime numbers
    let mut total: u32 = 0;
    for i in 0..max {
        if !nums[i] {
            total += 1;
        }
    }
    print!("{}",total);
}
