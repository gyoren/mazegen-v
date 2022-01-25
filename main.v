import os
import rand

fn print_maze_matrix(mat [][]int, curr_pos []int) {
	for i in 0..mat.len * mat.len {
		if [i % mat.len, i / mat.len] == curr_pos {
			print("<>")
		} else {
			print(match mat[i / mat.len][i % mat.len] {
				0 { "  " }
				1 { "██" }
				else {
					println("what")
					exit(1)
				}
			})
		}

		if i % mat.len == mat.len - 1 {
			print("\n")
		}
	}
}

fn get_available_directions(width int, pos []int, visited [][]int) [][]int {
	x := pos[0]
	y := pos[1]

	return [[x, y-2], [x+2, y], [x, y+2], [x-2, y]].filter(it[0] > 0 && it[1] > 0 && it[0] < width * 2 + 1 && it[1] < width * 2 + 1 && !(it in visited))
}

if os.args.len != 2 {
	println("Usage: ${os.file_name(os.args[0])} [maze width]")
	exit(1)
}

// maze creation
maze_width := os.args[1].int()

if maze_width < 1 {
	println("Invalid maze width provided")
	exit(1)
}

mut maze_matrix := []int{len: 2 * maze_width + 1}.map([]int{len: 2 * maze_width + 1}) // little hack to create a 2d array with specific dimension sizes

// maze matrix setup and output
for i in 0..maze_matrix.len {
	for j in 0..maze_matrix.len {
		if i in [0, maze_matrix.len - 1] || j in [0, maze_matrix.len - 1] || (i % 2 == 0 && j % 2 == 0) || (i+j) % 2 != 0 {
			maze_matrix[i][j] = 1
		}
	}
}

// setting up the starting point which can only be besides the outer walls

start_y := rand.intn(maze_width) * 2 + 1
mut start_x := 0

if start_y in [1, maze_width * 2 + 1] {
	start_x = rand.intn(maze_width) * 2 + 1
} else {
	start_x = [0, maze_width - 1][rand.intn(2)] * 2 + 1
}

// actual algorithm from this point on
mut visited_cells := [][]int{}
mut directions := [][]int{}
mut direction_cell := []int{}

mut path_history := [][]int{len: maze_width * maze_width}
mut i := 0

path_history[0] = [start_x, start_y]
visited_cells << [start_x, start_y]

mut current_cell := [start_x, start_y]

for {
	if visited_cells.len == maze_width * maze_width {
		break
	}
	directions = get_available_directions(maze_width, current_cell, visited_cells)
	if directions == [] {
		for {
			i--
			current_cell = path_history[i]
			directions = get_available_directions(maze_width, current_cell, visited_cells)
			if directions != [] {
				break
			}
		}
	}
	direction_cell = directions[rand.intn(directions.len)]
	maze_matrix[(current_cell[1] + direction_cell[1]) / 2][(current_cell[0] + direction_cell[0]) / 2] = 0
	current_cell = direction_cell.clone()
	visited_cells << current_cell
	path_history[i++] = current_cell
}

print_maze_matrix(maze_matrix, current_cell)