use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    for i in 0_i64..250_000 {
        scores.insert(i, i * 2);
    }
    let total: i64 = (0_i64..250_000)
        .filter_map(|key| scores.get(&key))
        .sum();
    println!("{total}");
}
