# Ví dụ game

## Mục tiêu

Ví dụ này mô phỏng vòng lặp game đơn giản bằng object, match và function. Nó không phụ thuộc engine đồ họa, nhưng cho thấy cách tổ chức state.

## Code

```vut
class Player(name) {
    name = name
    hp = 10

    fn hit(damage) {
        self.hp = self.hp - damage
    }

    fn alive() {
        return self.hp > 0
    }
}

fn apply_action(player, action) {
    match action {
        "hit" => player.hit(3)
        "heal" => player.hp = player.hp + 2
        _ => out("unknown action")
    }
}

let p = Player("nam")

for turn in 1..4 {
    apply_action(p, "hit")
    out("{p.name}: {p.hp}")

    if !p.alive() {
        out("game over")
        break
    }
}
```

## Giải thích

`Player` là class dynamic với field và method. `self` trỏ đến instance hiện tại. `match` xử lý action rõ ràng hơn chuỗi `if` dài.

## Best practices

Giữ state trong object nhỏ. Dùng function cho rule game. Khi game lớn hơn, tách `player.vut`, `world.vut`, `systems.vut` thành module riêng.

## Mo rong thuc hanh

- Chay lai vi du trong bai voi nhieu input khac nhau de nam chac hanh vi.
- Tach logic thanh ham/module nho de de test va tai su dung.
- Thu tao 1 tinh huong loi co chu dich de hieu thong diep chan doan cua Vut.

## Bai ke tiep

- Ban da xong lo trinh co ban. Quay lai [README](../README.md) de chon nhanh hoc tiep theo.

