let total = 0;

for (let i = 1; i <= 500000; i++) {
  total += i;
  total -= 1;
  total *= 2;
  total /= 2;
}

console.log(total);
