fn main() {
    let mut bytes = Vec::new();
    for _ in 0..1_000_000 {
        bytes.push(3_u8);
    }
    let total: u64 = bytes.iter().map(|byte| u64::from(*byte)).sum();
    println!("{total}");
}
