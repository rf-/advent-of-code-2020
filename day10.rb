require 'active_support/all'
require 'pp'
require 'pry'
require 'set'
require './lib/extensions'

adapters = File.read('day10.input').strip.lines.map(&:to_i).sort

# Part 1

differences = [adapters[0], *adapters.each_cons(2).map { _2 - _1 }, 3]
result_1 = differences.count(1) * differences.count(3)

puts result_1 # 2240

# Part 2

paths_to_device = Hash.new do |h, jolts|
  h[jolts] = (
    options = adapters.select { |n| n > jolts && n <= jolts + 3 }
    if options.empty?
      1 # this is the last one
    else
      options.map { paths_to_device[_1] }.sum
    end
  )
end

result_2 = paths_to_device[0]

puts result_2 # 99214346656768
