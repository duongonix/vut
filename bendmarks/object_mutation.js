const state = { count: 0, bonus: 3 };

for (let i = 1; i <= 250000; i++) {
  state.count += i;
  state.count -= state.bonus;
}

console.log(state.count);
