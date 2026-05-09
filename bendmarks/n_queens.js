function is_safe(cols, row, col) {
  let r = 0

  while (r < row) {
    let c = cols[r]

    if (c === col) {
      return false
    }

    if (c - r === col - row) {
      return false
    }

    if (c + r === col + row) {
      return false
    }

    r = r + 1
  }

  return true
}

function solve(cols, row, n) {
  let count = 0
  let current_row = row

  while (current_row >= 0) {
    cols[current_row] = cols[current_row] + 1

    let placed = false

    while (cols[current_row] < n) {
      if (is_safe(cols, current_row, cols[current_row])) {
        placed = true
        break
      }

      cols[current_row] = cols[current_row] + 1
    }

    if (placed) {
      if (current_row === n - 1) {
        count = count + 1
      } else {
        current_row = current_row + 1
        cols[current_row] = -1
      }
    } else {
      current_row = current_row - 1
    }
  }

  return count
}

function n_queens(n) {
  let cols = []

  for (let i = 0; i < n; i++) {
    cols.push(-1)
  }

  return solve(cols, 0, n)
}

console.log(n_queens(10))