import os
import rand

struct Cell {
	x int
	y int
	walls []int
}

fn print_maze_matrix(mat [][]int) {
	println(
		mat.map(it.map(it.str()).join("")).join("\n").replace("0", "  ").replace("1", "██")
	)
}

if os.args.len != 2 {
	println("Usage: ${os.file_name(os.args[0])} [maze width]")
	exit(1)
}

// maze creation
maze_width := os.args[1].int()
mut maze_matrix := []int{len: 2 * maze_width + 1}.map([]int{len: 2 * maze_width + 1}) // little hack to create a 2d array with specific dimension sizes

// maze matrix setup and output
for i in 0..maze_matrix.len {
	for j in 0..maze_matrix.len {
		if i in [0, maze_matrix.len - 1] || j in [0, maze_matrix.len - 1] || (i % 2 == 0 && j % 2 == 0) {
			maze_matrix[i][j] = 1
		}
	}
}

starting_point := [rand.int_in_range(0, maze_width), rand.int_in_range(0, maze_width)].map(it * 2 + 1)

println("Starting point: ${starting_point}")

print_maze_matrix(maze_matrix)