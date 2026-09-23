use std::hint::black_box;

fn count_primes(limit: i64) -> i64 {
    let mut count = 0;
    let mut number = 2;
    while number < limit {
        let mut prime = true;
        let mut divisor = 2;
        while divisor * divisor <= number {
            if number % divisor == 0 {
                prime = false;
                break;
            }
            divisor += 1;
        }
        if prime {
            count += 1;
        }
        number += 1;
    }
    count
}

fn main() {
    let limit = black_box(400_000);
    let result = count_primes(limit);
    println!("primes below 400000: {result}");
}
