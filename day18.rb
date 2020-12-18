require './shared'

input = File.read('day18.input').strip.lines.map(&:chomp)

parsed = input.map do |line|
  eval("[" + line.gsub(/([+*])/, ", :\\1, ").tr('()', '[]') + "]")
end

evaluate = -> (expr, &next_op) do
  expr = expr.map do |term|
    term.is_a?(Array) ? evaluate.(term, &next_op) : term
  end

  while expr.length > 1
    op_idx = next_op.(expr)
    left, op, right = expr[op_idx - 1 .. op_idx + 1]
    expr[op_idx - 1 .. op_idx + 1] = left.send(op, right)
  end

  expr[0]
end

# Part 1

next_op_1 = -> (expr) { expr.find_index { _1.is_a?(Symbol) } }
result_1 = parsed.map { |expr| evaluate.(expr, &next_op_1) }.sum

puts result_1 # 25190263477788

# Part 2

next_op_2 = -> (expr) { expr.index(:+) || expr.index(:*) }
result_2 = parsed.map { |expr| evaluate.(expr, &next_op_2) }.sum

puts result_2 # 297139939002972
