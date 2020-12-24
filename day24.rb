require './shared'

include PointOps[:y_up]
using PointOps[:y_up]

neighbor_deltas = {
  'e' => [1, 0],
  'w' => [-1, 0],
  'se' => [0, -1],
  'sw' => [-1, -1],
  'ne' => [1, 1],
  'nw' => [0, 1],
}

input = File.read('day24.input').strip.lines.map(&:chomp)
grid = Set.new

# Part 1

input.each do |line|
  coords = [0, 0]
  line.scan(/e|w|se|sw|ne|nw/).each do |direction|
    coords = coords.plus(neighbor_deltas[direction])
  end
  if grid.include?(coords)
    grid.delete(coords)
  else
    grid.add(coords)
  end
end

puts grid.size # 277

# Part 2

step = -> (grid) do
  new_grid = grid.dup

  coords_to_visit = grid.dup
  grid.each do |grid_coords|
    coords_to_visit.merge(neighbor_deltas.map { grid_coords.plus(_2) })
  end

  coords_to_visit.each do |coords|
    is_black = grid.include?(coords)
    neighbors = neighbor_deltas.count { grid.include?(coords.plus(_2)) }
    if is_black && (neighbors == 0 || neighbors > 2)
      new_grid.delete(coords)
    elsif !is_black && neighbors == 2
      new_grid.add(coords)
    end
  end

  new_grid
end

100.times do
  grid = step.(grid)
end

puts grid.size # 3531
