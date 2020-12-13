require './shared'

include PointOps[:y_up]
using PointOps[:y_up]

instructions = File.read('day12.input').strip.lines.map do
  _1 =~ /^(\w)(\d+)$/ && [$1, $2.to_i]
end

# Part 1

pos = [0, 0]
direction = RIGHT
instructions.each do |action, value|
  case action
  when 'N'
    pos = pos.plus(UP.times(value))
  when 'S'
    pos = pos.plus(DOWN.times(value))
  when 'E'
    pos = pos.plus(RIGHT.times(value))
  when 'W'
    pos = pos.plus(LEFT.times(value))
  when 'L'
    (value / 90).times { direction = direction.rotate_left }
  when 'R'
    (value / 90).times { direction = direction.rotate_right }
  when 'F'
    pos = pos.plus(direction.times(value))
  end
end

result_1 = pos.taxicab_distance

puts result_1 # 923

# Part 2

grid = Grid.new(:y_up)
pos = [0, 0]
waypoint = [10, 1]
instructions.each do |action, value|
  case action
  when 'N'
    waypoint = waypoint.plus(UP.times(value))
  when 'S'
    waypoint = waypoint.plus(DOWN.times(value))
  when 'E'
    waypoint = waypoint.plus(RIGHT.times(value))
  when 'W'
    waypoint = waypoint.plus(LEFT.times(value))
  when 'L'
    (value / 90).times { waypoint = waypoint.rotate_left }
  when 'R'
    (value / 90).times { waypoint = waypoint.rotate_right }
  when 'F'
    pos = pos.plus(waypoint.times(value))
  end
end

result_2 = pos.taxicab_distance

puts result_2 # 24769
