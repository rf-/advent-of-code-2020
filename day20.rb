require './shared'

include PointOps[:y_down]
using PointOps[:y_down]

input = File.read('day20.input').strip

sides = -> (grid) do
  x_min, x_max, y_min, y_max = grid.bounds
  left = (y_min..y_max).map { grid[x_min, _1] }
  top = (x_min..x_max).map { grid[_1, y_min] }
  right = (y_min..y_max).map { grid[x_max, _1] }
  bottom = (x_min..x_max).map { grid[_1, y_max] }
  [left, top, right, bottom]
end

permute = -> (grid) do
  rotations = 4.times.map do |turns|
    grid.transform_keys do |coords|
      turns.times { coords = coords.rotate_right }
      coords
    end
  end

  rotations.flat_map do |grid|
    [grid, grid.transform_keys { |(x, y),| [-x, y] }]
  end
end

tiles = input.split("\n\n").map do |str|
  str = str.lines
  id = str[0][/\d+/].to_i
  grid = Grid.new(:y_down, default: '.')
  raw = str[1..].map(&:chomp)
  grid.fill(raw[0].length, raw.length, raw.flat_map { |l| l.split('') })
  [id, permute.(grid)]
end.to_h

tiles_by_side = Hash.new { _1[_2] = [] }
tiles.each do |id, grids|
  grids.each_with_index do |grid, grid_idx|
    sides.(grid).each_with_index do |side, side_idx|
      tiles_by_side[[side, side_idx]] << [id, grid_idx]
    end
  end
end

grid = { [0, 0] => [tiles.keys[0], 0] }
remaining_tile_ids = tiles.keys[1..].to_set

first_tile_sides = sides.(tiles[tiles.keys[0]][0])
pending_sides = Grid::ORTHOGONAL_NEIGHBORS.map.with_index do |coord, side_idx|
  side = first_tile_sides[side_idx]
  [coord, side, (side_idx + 2) % 4]
end

while remaining_tile_ids.any?
  coords, side, side_idx = pending_sides.pop
  next if grid.key?(coords)
  grid_ids = tiles_by_side[[side, side_idx]].find { |id, _| remaining_tile_ids.include?(id) }
  if grid_ids
    grid[coords] = grid_ids
    remaining_tile_ids.delete(grid_ids[0])
    tile_sides = sides.(tiles[grid_ids[0]][grid_ids[1]])
    Grid::ORTHOGONAL_NEIGHBORS.each_with_index do |delta, side_idx|
      cs = coords.plus(delta)
      if !grid.key?(cs)
        side = tile_sides[side_idx]
        pending_sides << [cs, side, (side_idx + 2) % 4]
      end
    end
  end
end

min_x = grid.keys.map(&:first).min
max_x = grid.keys.map(&:first).max
min_y = grid.keys.map(&:second).min
max_y = grid.keys.map(&:second).max

# Part 1

result_1 = [[min_x, min_y], [min_x, max_y], [max_x, min_y], [max_x, max_y]]
  .map { |coords| grid[coords][0] }
  .reduce(:*)

puts result_1 # 66020135789767

# Part 2

full_grid = Grid.new(:y_down, default: '.')

grid.each do |(x, y), (tile_id, grid_idx)|
  tiles[tile_id][grid_idx].visualize.lines.each_with_index do |line, dy|
    line.chomp.chars.each_with_index do |char, dx|
      full_grid[(x - min_x) * 8 + dx, (y - min_y) * 8 + dy] = char
    end
  end
end

drawing = <<EOS
                  #
#    ##    ##    ###
 #  #  #  #  #  #
EOS

drawing_coords = drawing.split("\n").flat_map.with_index do |line, y|
  line.split('').map.with_index { |char, x| [x, y] if char == '#' }.compact
end

search_grid = -> (grid) do
  has_match = false
  grid.keys.count do |x, y|
    is_match = drawing_coords.all? { grid[x + _1, y + _2] == '#' }
    if is_match
      has_match = true
      drawing_coords.each { grid[x + _1, y + _2] = 'O' }
    end
  end
  has_match
end

result_2 = permute.(full_grid).find_map do |grid|
  grid.values.count('#') if search_grid.(grid)
end

puts result_2 # 2585
