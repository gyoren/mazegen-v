import os

struct Cell {
	x int
	y int
	walls []int
}

if os.args.len != 2 {
	println("Usage: ${os.args[0]} [maze width]")
}

// maze creation
maze_width := os.args[1].int()
mut maze_matrix := []int{len: 2 * maze_width + 1}.map([]int{len: 2 * maze_width + 1}) // little hack to create a 2d array with specific dimension sizes

// maze matrix setup and output
for i in 0..maze_matrix.len {
	for j in 0..maze_matrix.len {
		if i in [0, maze_matrix.len - 1] || j in [0, maze_matrix.len - 1] {
			maze_matrix[i][j] = 1
			if j == maze_matrix.len - 1 {
				println("██")
			} else {
				print("██")
			}
		} else if i % 2 == 0 && j % 2 == 0 {
			maze_matrix[i][j] = 1
			print("██")
		} else {
			print("  ")
		}
	}
}