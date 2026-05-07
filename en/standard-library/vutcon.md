# `vutcon` Module

## Goal

`vutcon` is Vut's standard concurrency module. Concurrency is not a special language keyword; it is a regular module API.

```vut
import vutcon at spawn

spawn(() {
    out("hello")
})
```

This design avoids conflicts with VutCom syntax and keeps the runtime model simple.

## Import

```vut
import vutcon
import vutcon at spawn, channel
import vutcon as vc
```

```vut
import vutcon as vc

vc.spawn(() {
    out("worker")
})
```

## Spawn task

`spawn` takes a lambda.

```vut
import vutcon at spawn

spawn(() {
    out("hello from task")
})
```

Use lambda-call syntax:

```vut
spawn(() {
    out("correct")
})
```

Do not use block syntax:

```text
spawn {
    ...
}
```

That syntax is intentionally avoided because it can conflict with VutCom.

## Program lifecycle

Vut has no `fn main()`. Top-level file execution is the entry point. When top-level execution finishes, the runtime waits for all non-detached tasks to complete before exiting.

```vut
import vutcon at spawn

spawn(() {
    out("worker")
})

out("main done")
```

Detached tasks are optional:

```vut
import vutcon at spawn

spawn(() {
    out("background")
}, detached = true)
```

A detached task does not keep the runtime alive.

## Channel

Channels are the primary primitive for communication between tasks.

```vut
import vutcon at spawn, channel

let ch = channel()

spawn(() {
    ch.send("hello from worker")
})

out(ch.receive())
```

Channels are thread-safe and support multiple producers and consumers.

## Timeout receive

```vut
import vutcon at channel

let ch = channel()
let msg = ch.receive(timeout = 1000)

if msg == null {
    out("timeout")
}
```

Timeouts are expressed in milliseconds.

## Worker pool

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

This model encourages message passing instead of shared mutable state.

## Select

`select` also takes a lambda.

```vut
import vutcon at select

select(() {
    msg = ch1.receive() => out(msg)
    msg = ch2.receive() => out(msg)
    timeout 1000 => out("timeout")
})
```

Rules:

- The first available branch wins.
- Timeout is optional.
- Only one branch executes.
- Each branch has its own scope.

Do not use:

```text
select {
    ...
}
```

## Sleep

```vut
import vutcon at sleep

sleep(1000)
out("after one second")
```

`sleep(ms)` suspends the current task for the given number of milliseconds.

## Diagnostics

Concurrency errors use the `E6100` group:

- `E6101` channel closed
- `E6102` send failed
- `E6103` receive failed
- `E6104` invalid select branch
- `E6105` spawn failed
- `E6106` thread panic
- `E6107` timeout value invalid

## Best practices

Prefer sending messages through channels. Avoid sharing mutable objects across tasks unless it is truly necessary. For long-running workers, send a clear command such as `"stop"` or a command object so the task can shut down by itself.
