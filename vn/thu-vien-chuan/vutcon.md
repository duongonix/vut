# Module `vutcon`

## Mục tiêu

`vutcon` là standard module cho concurrency của Vut. Concurrency không phải keyword đặc biệt của language; nó là API module bình thường.

```vut
import vutcon at spawn

spawn(() {
    out("hello")
})
```

Thiết kế này giúp syntax không xung đột với VutCom và giữ runtime đơn giản.

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

`spawn` nhận lambda.

```vut
import vutcon at spawn

spawn(() {
    out("hello from task")
})
```

Không dùng block syntax:

```vut
spawn(() {
    out("correct")
})
```

```text
spawn {
    ...
}
```

Syntax trên không dùng trong Vut vì dễ xung đột với VutCom.

## Program lifecycle

Vut không có `fn main()`. File top-level là entry point. Khi top-level chạy xong, runtime chờ các non-detached task hoàn thành rồi mới thoát.

```vut
import vutcon at spawn

spawn(() {
    out("worker")
})

out("main done")
```

Detached task là optional:

```vut
import vutcon at spawn

spawn(() {
    out("background")
}, detached = true)
```

Detached task không giữ runtime sống.

## Channel

Channel là primitive chính để giao tiếp giữa các task.

```vut
import vutcon at spawn, channel

let ch = channel()

spawn(() {
    ch.send("hello from worker")
})

out(ch.receive())
```

Channel thread-safe và hỗ trợ nhiều producer/consumer.

## Timeout receive

```vut
import vutcon at channel

let ch = channel()
let msg = ch.receive(timeout = 1000)

if msg == null {
    out("timeout")
}
```

Timeout tính bằng millisecond.

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

Model này khuyến khích message passing thay vì shared mutable state.

## Select

`select` cũng nhận lambda.

```vut
import vutcon at select

select(() {
    msg = ch1.receive() => out(msg)
    msg = ch2.receive() => out(msg)
    timeout 1000 => out("timeout")
})
```

Rule:

- branch đầu tiên sẵn sàng sẽ chạy.
- timeout là optional.
- chỉ một branch được chạy.
- mỗi branch có scope riêng.

Không dùng:

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

`sleep(ms)` tạm dừng task hiện tại trong số millisecond tương ứng.

## Diagnostics

Nhóm lỗi concurrency dùng `E6100`:

- `E6101` channel closed
- `E6102` send failed
- `E6103` receive failed
- `E6104` invalid select branch
- `E6105` spawn failed
- `E6106` thread panic
- `E6107` timeout value invalid

## Best practices

Ưu tiên gửi message qua channel. Tránh chia sẻ object mutable giữa nhiều task nếu không thật sự cần. Với worker chạy lâu, gửi message `"stop"` hoặc một object command rõ ràng để task tự kết thúc.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- [vutcom/gioi-thieu.md](../vutcom/gioi-thieu.md)

