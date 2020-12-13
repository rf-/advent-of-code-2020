require './shared'

input = File.read('day9.input').strip.lines.map(&:chomp).map(&:to_i)

# Part 1

find_invalid_num = -> (window_size) do
  input.each_cons(window_size + 1) do |nums|
    previous = nums[0...window_size]
    cur = nums[window_size]
    return cur if previous.combination(2).none? { _1 + _2 == cur }
  end
end

result_1 = find_invalid_num.(25)

puts result_1 # 90433990

# Part 2

find_range = -> (target) do
  input.each_index do |idx|
    acc = 0
    input.each_with_index.drop(idx).each do |num, jdx|
      acc += num
      break if acc > target
      return [idx, jdx] if acc == target
    end
  end
end

first, last = find_range.(result_1)
nums = input[first..last]
result_2 = nums.min + nums.max

puts result_2 # 11691646
