require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.readlines('day1.input').map(&:chomp).map(&:to_i)

# Part 1

result_1 = INPUT
  .combination(2)
  .find { _1 + _2 == 2020 }
  .reduce(:*)

puts result_1 # 806656

# Part 2

result_2 = INPUT
  .combination(3)
  .find { _1.reduce(:+) == 2020 }
  .reduce(:*)

puts result_2 # 230608320
