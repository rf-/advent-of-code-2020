require './shared'

input = File.read('day13.input').strip.lines.map(&:chomp)

earliest_time = input[0].to_i
buses = input[1].split(',')
  .each_with_index
  .reject { |id,| id == 'x' }
  .map { _1.map(&:to_i) }

# Part 1

result_1 = buses
  .map { |id,| [id, (earliest_time.to_f / id).ceil * id] }
  .min_by { _2 }
  .then { _1 * (_2 - earliest_time) }

puts result_1 # 8063

# Part 2

t = 0
increment = 1
buses.each do |interval, offset|
  t += increment until (t + offset) % interval == 0
  increment *= interval
end

puts t # 775230782877242
