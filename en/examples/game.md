# Game Example

## Goal

This example models a simple game loop with objects, match, and functions. It does not depend on a graphics engine, but shows how to organize state.

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

## Explanation

`Player` is a dynamic class with fields and methods. `self` points to the current instance. `match` handles actions more clearly than a long chain of `if` statements.

## Best practices

Keep state in small objects. Use functions for game rules. As the game grows, split `player.vut`, `world.vut`, and `systems.vut` into separate modules.
