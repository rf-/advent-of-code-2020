require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.readlines('day3.input').map(&:chomp)

require './lib/grid'
grid = Grid.new(:y_down)
grid.fill(INPUT[0].length, INPUT.length, INPUT.flat_map { |l| l.split('') })

def trees(grid, dx, dy)
  coords = [0, 0]
  trees = 0
  while coords[1] < INPUT.length
    coords = [(coords[0] + dx) % INPUT[0].length, coords[1] + dy]
    trees += 1 if grid[*coords] == '#'
  end
  trees
end

# Part 1

result_1 = trees(grid, 3, 1)

puts result_1 # 169

# Part 2

result_2 = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
  .map { |dx, dy| trees(grid, dx, dy) }
  .inject(:*)

puts result_2 # 7560370818
