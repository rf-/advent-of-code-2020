require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.readlines('day2.input').map(&:chomp)

lines = INPUT.map do |line|
  match = line.match(/^(\d+)-(\d+) (.): (.*)$/)
  [match[1].to_i, match[2].to_i, match[3], match[4]]
end

# Part 1

result_1 = lines.count do |low, high, letter, password|
  (low..high).cover?(password.count(letter))
end

puts result_1 # 396

# Part 2

result_2 = lines.count do |low, high, letter, password|
  (password[low - 1] == letter) != (password[high - 1] == letter)
end

puts result_2 # 428
