require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.read('dayN.input').chomp
# or
INPUT = File.readlines('dayN.input').map(&:chomp)

# Part 1

result_1 = nil

puts result_1

# Part 2

result_2 = nil

puts result_2

Pry.start(binding, quiet: true)

# require './lib/grid'
# grid = Grid.new(:y_down OR :y_up)
# grid.fill(INPUT[0].length, INPUT.length, INPUT.flat_map { |l| l.split('') })
# grid.bearing(pt1, pt2)
# grid.distance(pt1, pt2)

# require './lib/graph_utils'
# GraphUtils.topo_sort([[dependency, dependent], ...])

