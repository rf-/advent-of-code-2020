require './shared'

input = File.read('day18.input').strip.lines.map(&:chomp)

# Part 1

evaluate_1 = -> (expr) do
  expr = expr.dup
  while expr !~ /^(\d+)$/
    expr.sub!(/\((\d+)\)/) { $1.to_i } ||
    expr.sub!(/(\d+) ([+*]) (\d+)/) { $1.to_i.send($2, $3.to_i) }
  end
  $1.to_i
end

puts input.map(&evaluate_1).sum # 25190263477788

# Part 2

evaluate_2 = -> (expr) do
  expr = expr.dup
  while expr !~ /^(\d+)$/
    expr.sub!(/\((\d+)\)/) { $1.to_i } ||
    expr.sub!(/(\d+) \+ (\d+)/) { $1.to_i + $2.to_i } ||
    expr.sub!(/(\d+) \* (\d+)/) { $1.to_i * $2.to_i }
  end
  $1.to_i
end

puts input.map(&evaluate_2).sum # 297139939002972
