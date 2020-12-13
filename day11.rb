require './shared'

input = File.read('day11.input').strip.lines.map(&:chomp)
grid = Grid.new
grid.fill(input[0].length, input.length, input.flat_map { |l| l.split('') })

step = -> (grid, line_of_sight: false, threshold: 4) do
  grid.map do |(x, y), cell|
    adjacent_count =
      if line_of_sight
        grid.visible_neighbors(x, y) { _1 != '.' }.count('#')
      else
        grid.neighbors(x, y).count('#')
      end

    if cell == 'L' && adjacent_count == 0
      '#'
    elsif cell == '#' && adjacent_count >= threshold
      'L'
    else
      cell
    end
  end
end

# Part 1

prev_grid = grid
result_1 = loop do
  next_grid = step.(prev_grid)
  break prev_grid.values.count('#') if prev_grid == next_grid
  prev_grid = next_grid
end

puts result_1 # 2354

# Part 2

prev_grid = grid
result_2 = loop do
  next_grid = step.(prev_grid, line_of_sight: true, threshold: 5)
  break prev_grid.values.count('#') if prev_grid == next_grid
  prev_grid = next_grid
end

puts result_2 # 2072
