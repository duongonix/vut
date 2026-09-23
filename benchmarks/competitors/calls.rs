#[inline(never)]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

fn main() {
    let mut total: i64 = 0;
    let mut i: i64 = 0;
    while i < 1_000_000 {
        total = add(total, 1);
        i += 1;
    }
    println!("{total}");
}
