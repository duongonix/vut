fn main() {
    let values: [i64; 5] = [1, 2, 3, 4, 5];
    let mut total: i64 = 0;
    let mut i = 0usize;
    while i < values.len() {
        total += values[i];
        i += 1;
    }
    println!("{total}");
}
