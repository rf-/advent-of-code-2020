require './shared'

INPUT = File.readlines('day3.input').map(&:chomp)

grid = Grid.new(:y_down)
grid.fill(INPUT[0].length, INPUT.length, INPUT.flat_map { |l| l.split('') })

count_trees = -> (dx, dy) do
  coords = [0, 0]
  trees = 0
  while coords[1] < INPUT.length
    coords = [(coords[0] + dx) % INPUT[0].length, coords[1] + dy]
    trees += 1 if grid[*coords] == '#'
  end
  trees
end

# Part 1

result_1 = count_trees.(3, 1)

puts result_1 # 169

# Part 2

result_2 = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
  .map { count_trees.(_1, _2) }
  .inject(:*)

puts result_2 # 7560370818
