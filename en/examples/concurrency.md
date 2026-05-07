# Concurrency Example

## Goal

This example uses `vutcon` to create workers, send jobs through a channel, and receive results.

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

## Explanation

`spawn` takes a lambda, not a block keyword. Channels are the main communication mechanism. Top-level file execution is the entry point, and the runtime waits for non-detached tasks to complete.

## Best practices

Send a clear stop command such as `"stop"`. Avoid shared mutable state. If you need timeouts, use `receive(timeout = 1000)` or `select(() { ... })`.
