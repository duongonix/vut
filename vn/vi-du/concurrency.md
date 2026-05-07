# Ví dụ concurrency

## Mục tiêu

Ví dụ này dùng `vutcon` để tạo worker, gửi job qua channel và nhận kết quả.

## Code

```vut
import vutcon at spawn, channel

let jobs = channel()
let results = channel()

for i in 1..4 {
    spawn(() {
        while true {
            let job = jobs.receive()

            if job == "stop" {
                break
            }

            results.send(job * 2)
        }
    })
}

for i in 1..10 {
    jobs.send(i)
}

for i in 1..4 {
    jobs.send("stop")
}

for i in 1..10 {
    out(results.receive())
}
```

## Giải thích

`spawn` nhận lambda, không phải block keyword. Channel là cơ chế giao tiếp chính. Top-level file là entry point; runtime chờ non-detached task hoàn thành.

## Best practices

Gửi command dừng rõ ràng như `"stop"`. Tránh shared mutable state. Nếu cần timeout, dùng `receive(timeout = 1000)` hoặc `select(() { ... })`.
