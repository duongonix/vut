const values = [];

for (let i = 0; i <= 6000; i++) {
  values.push(i);
}

let total = 0;
for (const value of values) {
  total += value;
}

console.log(total);
