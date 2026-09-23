fn count_primes(limit: i64) -> i64 {
    let mut count = 0i64;
    let mut number = 2i64;
    while number < limit {
        let mut prime = true;
        let mut divisor = 2i64;
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
    println!("primes below 400000: {}", count_primes(400_000));
}
