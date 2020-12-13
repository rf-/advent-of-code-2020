require 'active_support/all'
require 'pp'
require 'pry'
require 'set'
require './lib/extensions'
require './lib/grid'

instructions = File.read('day12.input').strip.lines.map do
  _1 =~ /^(\w)(\d+)$/ && [$1, $2.to_i]
end

# Part 1

grid = Grid.new(:y_up)
pos = [0, 0]
direction = Grid::RIGHT
instructions.each do |action, value|
  case action
  when 'N'
    pos = grid.move(Grid::UP, pos, value)
  when 'S'
    pos = grid.move(Grid::DOWN, pos, value)
  when 'E'
    pos = grid.move(Grid::RIGHT, pos, value)
  when 'W'
    pos = grid.move(Grid::LEFT, pos, value)
  when 'L'
    (value / 90).times { direction = direction.turn_left }
  when 'R'
    (value / 90).times { direction = direction.turn_right }
  when 'F'
    pos = grid.move(direction, pos, value)
  end
end

result_1 = pos.map(&:abs).sum

puts result_1 # 923

# Part 2

grid = Grid.new(:y_up)
pos = [0, 0]
waypoint = [10, 1]
instructions.each do |action, value|
  case action
  when 'N'
    waypoint = grid.move(Grid::UP, waypoint, value)
  when 'S'
    waypoint = grid.move(Grid::DOWN, waypoint, value)
  when 'E'
    waypoint = grid.move(Grid::RIGHT, waypoint, value)
  when 'W'
    waypoint = grid.move(Grid::LEFT, waypoint, value)
  when 'L'
    (value / 90).times do
      waypoint = [-waypoint[1], waypoint[0]]
    end
  when 'R'
    (value / 90).times do
      waypoint = [waypoint[1], -waypoint[0]]
    end
  when 'F'
    value.times do
      pos = [pos[0] + waypoint[0], pos[1] + waypoint[1]]
    end
  end
end

result_2 = pos.map(&:abs).sum

puts result_2 # 24769
