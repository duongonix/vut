let checksum = 0;

for (let round = 1; round <= 20000; round++) {
  let a = 0;
  let b = 1;
  for (let i = 2; i <= 35; i++) {
    let next = a + b;
    a = b;
    b = next;
  }
  checksum += b;
}

console.log(checksum);
