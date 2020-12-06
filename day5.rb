require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.readlines('day5.input').map(&:chomp)

seat_ids = INPUT.map { _1.tr('FBLR', '0101').to_i(2) }

# Part 1

result_1 = seat_ids.max

puts result_1 # 888

# Part 2

neighbors = seat_ids.sort.each_cons(2).find { _1 + 2 == _2 }
result_2 = neighbors[0] + 1

puts result_2 # 522
