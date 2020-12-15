require './shared'

input = File.read('day15.input').strip.split(',').map(&:to_i)

calculate_last_num = -> (limit) do
  history = Hash.new { _1[_2] = [] }
  num = nil
  turn = 0

  input.each do |input_num|
    num = input_num
    history[num] << turn
    turn += 1
  end

  while turn < limit
    if history[num].length > 1
      num = history[num][-1] - history[num][-2]
    else
      num = 0
    end
    history[num] << turn
    turn += 1
  end

  num
end

# Part 1

puts calculate_last_num.(2020) # 1025

# Part 2

puts calculate_last_num.(30_000_000) # 129262
