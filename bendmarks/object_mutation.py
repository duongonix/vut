state = {"count": 0, "bonus": 3}

for i in range(1, 250001):
    state["count"] += i
    state["count"] -= state["bonus"]

print(state["count"])
