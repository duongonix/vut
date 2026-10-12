fn main() {
    let limit = 50_000_000;
    let mut i: i64 = 0;
    let mut state: i64 = 0;
    while i < limit {
        state = (state * 33 + i % 2) % 2_147_483_648;
        i += 1;
    }
    println!("{state}");
}
