module mazegen_v

import rand

pub fn print_maze(mat [][]int) {
	for i in 0..mat.len * mat.len {
		print(match mat[i / mat.len][i % mat.len] {
			0 { "  " }
			1 { "██" }
			else {
				println("what")
				exit(1)
			}
		})

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

// generate generates the maze, using `width` for the width of the maze in tiles
// the returned array of arrays of integers uses 0 for an empty spot and 1 for a wall tile
pub fn generate(width int) [][]int {

	if width < 1 {
		println("Invalid maze width provided")
		exit(1)
	}

	mut maze_matrix := []int{len: 2 * width + 1}.map([]int{len: 2 * width + 1}) // little hack to create a 2d array with specific dimension sizes

	// maze matrix setup and output

	for i in 0..maze_matrix.len {
		for j in 0..maze_matrix.len {
			if i in [0, maze_matrix.len - 1] || j in [0, maze_matrix.len - 1] || (i % 2 == 0 && j % 2 == 0) || (i+j) % 2 != 0 {
				maze_matrix[i][j] = 1
			}
		}
	}

	// setting up the starting point which can only be besides the outer walls

	start_y := rand.intn(width) * 2 + 1
	mut start_x := 0

	if start_y in [1, width * 2 + 1] {
		start_x = rand.intn(width) * 2 + 1
	} else {
		start_x = [0, width - 1][rand.intn(2)] * 2 + 1
	}

	// algorithm

	mut visited_tiles := [][]int{}
	mut directions := [][]int{}
	mut direction_tile := []int{}

	mut path_history := [][]int{len: width * width}
	mut i := 0

	path_history[0] = [start_x, start_y]
	visited_tiles << [start_x, start_y]

	mut current_tile := [start_x, start_y]

	for {
		if visited_tiles.len == width * width {
			break
		}
		directions = get_available_directions(width, current_tile, visited_tiles)
		if directions == [] {
			for {
				i--
				current_tile = path_history[i]
				directions = get_available_directions(width, current_tile, visited_tiles)
				if directions != [] {
					break
				}
			}
		}
		direction_tile = directions[rand.intn(directions.len)]
		maze_matrix[(current_tile[1] + direction_tile[1]) / 2][(current_tile[0] + direction_tile[0]) / 2] = 0
		current_tile = direction_tile.clone()
		visited_tiles << current_tile
		i++
		path_history[i] = current_tile
	}

	return maze_matrix
}