let total = 0;

for (let i = 1; i <= 700; i++) {
  for (let j = 1; j <= 700; j++) {
    total += i;
    total += j;
  }
}

console.log(total);
