fn main() {
    let mut items = Vec::new();
    for i in 0_i64..1_000_000 {
        items.push(i);
    }
    let total: i64 = items.iter().sum();
    println!("{total}");
}
