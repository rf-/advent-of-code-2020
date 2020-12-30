require './shared'

input = File.read('day16.input')

defs = input.scan(/^(.+): (.+)-(.+) or (.+)-(.+)$/).map do |name, *bounds|
  bounds = bounds.map(&:to_i)
  [name, bounds[0]..bounds[1], bounds[2]..bounds[3]]
end

your_ticket = input[/your ticket:\n(.*?)\n/, 1]
  .split(',').map(&:to_i)

nearby_tickets = input[/nearby tickets:\n(.*)/m, 1].split("\n")
  .map { _1.split(',').map(&:to_i) }

all_ranges = defs.flat_map { [_2, _3] }

bad_values = nearby_tickets.map do |values|
  values.select { |value| all_ranges.none? { |range| range.cover?(value) } }
end

# Part 1

puts bad_values.flatten.sum # 29878

# Part 2

good_tickets = nearby_tickets.select.with_index do |_, ticket_idx|
  bad_values[ticket_idx].empty?
end

possible_def_indices = Array.new(nearby_tickets[0].length).fill do
  (0...defs.length).to_a
end

good_tickets.each do |values|
  values.each_with_index do |value, field_idx|
    valid_defs = defs.each_with_index.select do |(_, r1, r2), _|
      r1.cover?(value) || r2.cover?(value)
    end
    possible_def_indices[field_idx] &= valid_defs.map(&:second)
  end
end

resolved_indices = Set.new
while (
  resolvable_index = possible_def_indices.find_map do |indices|
    indices[0] if indices.length == 1 && !resolved_indices.include?(indices[0])
  end
)
  possible_def_indices.each do |indices|
    indices.delete(resolvable_index) unless indices == [resolvable_index]
  end
  resolved_indices.add(resolvable_index)
end

field_values = possible_def_indices.filter_map.with_index do |(field_index, _), def_index|
  your_ticket[field_index] if (0...6).cover?(def_index)
end

puts field_values.reduce(:*) # 976478687521
