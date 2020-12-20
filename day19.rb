require './shared'

input = File.read('day19.input').strip

rules_raw, messages_raw = input.split("\n\n")

parse = -> (defn) do
  case defn
  in /^(.*) \| (.*)$/
    [$1, $2].map(&parse)
  in /^((\d+) ?)+$/
    $&.split(' ').map(&:to_i)
  in /^"(\w)"$/
    $1
  end
end

rules_by_id = rules_raw.lines.map do |rule|
  id, defn = rule.split(': ')
  [id.to_i, parse.(defn)]
end.to_h

messages = messages_raw.lines.map(&:chomp)

apply_rule = -> (rule, remainder) do
  case rule
  in [Array => first, *others]
    remainders = apply_rule.(first, remainder)
    return remainders if others.empty?
    [*remainders, *apply_rule.(others, remainder)]
  in [Integer => first, *others]
    remainders = apply_rule.(first, remainder)
    return remainders if others.empty?
    remainders.flat_map { apply_rule.(others, _1) }
  in Integer => id
    apply_rule.(rules_by_id[id], remainder)
  in String => char
    char == remainder[0] ? [remainder[1..] || ""] : []
  end
end

matches_rule_0 = -> (message) { apply_rule.(0, message).include?("") }

# Part 1

puts messages.count(&matches_rule_0) # 198

# Part 2

rules_by_id[8] = [[42], [42, 8]]
rules_by_id[11] = [[42, 31], [42, 11, 31]]

puts messages.count(&matches_rule_0) # 372
