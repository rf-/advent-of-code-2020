require './shared'

input = File.read('day17.input').strip.lines.map(&:chomp)

neighbors = -> (coords) do
  result = [[]]
  coords.each do |coord|
    result = result.flat_map do |entry|
      (-1..1).map { |delta| [*entry, coord + delta] }
    end
  end
  result - [coords]
end

step = -> (grid) do
  possible_cells = Set.new
  grid.each do |coords|
    possible_cells.merge(neighbors.(coords))
  end

  new_grid = Set.new
  possible_cells.each do |coords|
    active = grid.include?(coords)
    count = neighbors.(coords).count { |neighbor| grid.include?(neighbor) }
    if active ? (2..3).cover?(count) : count == 3
      new_grid.add(coords)
    end
  end

  new_grid
end

# Part 1

grid3 = Set.new
input.each_with_index do |line, y|
  line.chars.each_with_index do |cell, x|
    grid3.add([x, y, 0]) if cell == '#'
  end
end

6.times { grid3 = step.(grid3) }
result_1 = grid3.size

puts result_1 # 269

# Part 2

grid4 = Set.new
input.each_with_index do |line, y|
  line.chars.each_with_index do |cell, x|
    grid4.add([x, y, 0, 0]) if cell == '#'
  end
end

6.times { grid4 = step.(grid4) }
result_2 = grid4.size

puts result_2 # 1380
