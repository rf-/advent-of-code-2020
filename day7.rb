require 'active_support/all'
require 'pp'
require 'pry'
require 'set'
require './lib/extensions'

INPUT = File.readlines('day7.input').map(&:chomp)

rules = Hash.new { _1[_2] = [] }
rules_inverted = Hash.new { _1[_2] = [] }

INPUT.each do |line|
  container_color = line[/^(.*?) bag/, 1]
  line.scan(/(\d+) (.+?) bag/).each do |count_raw, contained_color|
    count = count_raw.to_i
    rules[container_color].push([count, contained_color])
    rules_inverted[contained_color].push([count, container_color])
  end
end

# Part 1

count_containing_colors = -> (initial_color) do
  seen = Set.new
  pending = Set.new([initial_color])

  while pending.any?
    current_color = pending.pop
    seen.add(current_color)
    rules_inverted[current_color].each do |count, color|
      pending.add(color) unless seen.include?(color)
    end
  end

  seen.count - 1 # remove original color
end

result_1 = count_containing_colors.('shiny gold')

puts result_1 # 316

# Part 2

count_contained_bags = -> (color) do
  rules[color].sum do |count, contained_color|
    (1 + count_contained_bags.(contained_color)) * count
  end
end

result_2 = count_contained_bags.('shiny gold')

puts result_2 # 11310
