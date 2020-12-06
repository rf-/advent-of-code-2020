require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.read('day6.input')

groups = INPUT.split("\n\n").map do |lines|
  lines.split("\n").map { _1.chomp.chars }
end

# Part 1

result_1 = groups.map { _1.reduce(:|).count }.sum

puts result_1 # 6703

# Part 2

result_2 = groups.map { _1.reduce(:&).count }.sum

puts result_2 # 3430
