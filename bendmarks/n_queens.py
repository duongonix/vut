def is_safe(cols, row, col):
    r = 0

    while r < row:
        c = cols[r]

        if c == col:
            return False

        if c - r == col - row:
            return False

        if c + r == col + row:
            return False

        r = r + 1

    return True


def solve(cols, row, n):
    count = 0
    current_row = row

    while current_row >= 0:
        cols[current_row] = cols[current_row] + 1

        placed = False

        while cols[current_row] < n:
            if is_safe(cols, current_row, cols[current_row]):
                placed = True
                break

            cols[current_row] = cols[current_row] + 1

        if placed:
            if current_row == n - 1:
                count = count + 1
            else:
                current_row = current_row + 1
                cols[current_row] = -1
        else:
            current_row = current_row - 1

    return count


def n_queens(n):
    cols = []

    for i in range(n):
        cols.append(-1)

    return solve(cols, 0, n)


print(n_queens(10))