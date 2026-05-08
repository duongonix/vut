checksum = 0

for round in range(1, 20001):
    a = 0
    b = 1
    for i in range(2, 36):
        next_value = a + b
        a = b
        b = next_value
    checksum += b

print(checksum)
