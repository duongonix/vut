use std::hint::black_box;

fn main() {
    let mut total = 0.0_f64;
    let mut i = 0_i64;
    while i < 5_000_000 {
        let x = i as f64;
        total += x.sqrt() + (x - 3.0).abs() + x.floor() + x.ceil() + x.trunc();
        i += 1;
    }
    println!("{}", black_box(total) as i64);
}
