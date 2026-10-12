fn main() {
    let count = std::env::args().count() * 50_000;
    let mut text = String::new();
    for _ in 0..count {
        text.push_str("ab");
    }
    let tail = &text[text.len() - 2..];
    println!("{}:{tail}", text.len());
}
