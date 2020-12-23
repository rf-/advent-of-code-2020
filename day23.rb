require './shared'

input = '123487596'

Cup = Struct.new(:label, :next)

play = -> (labels, iterations) do
  min_label = labels.min
  max_label = labels.max

  current_cup = Cup.new(labels[0], nil)
  cups_by_label = { labels[0] => current_cup }

  last_cup = current_cup
  labels.drop(1).each do |label|
    next_cup = Cup.new(label, nil)
    cups_by_label[label] = next_cup
    last_cup.next = next_cup
    last_cup = next_cup
  end
  last_cup.next = current_cup

  pick_up_after = -> (cup) do
    next_cup = cup.next
    next_next_cup = next_cup.next
    cup.next = next_next_cup
    next_cup.next = nil
    next_cup
  end

  place_after = -> (cup, new_cup) do
    next_cup = cup.next
    cup.next = new_cup
    new_cup.next = next_cup
  end

  move = -> do
    picked_up_cups = 3.times.map { pick_up_after.(current_cup) }
    picked_up_labels = picked_up_cups.map(&:label)

    target_label = current_cup.label
    dest_label = loop do
      target_label -= 1
      target_label = max_label if target_label < min_label
      break target_label unless picked_up_labels.include?(target_label)
    end

    dest_cup = cups_by_label[dest_label]
    picked_up_cups.reverse_each { place_after.(dest_cup, _1) }
    current_cup = current_cup.next
  end

  iterations.times { move.() }

  cups_by_label[1]
end

# Part 1

labels = input.split('').map(&:to_i)

one_cup = play.(labels, 100)

result_1 = ''
cup = one_cup.next
until cup == one_cup
  result_1 << cup.label.to_s
  cup = cup.next
end

puts result_1 # 47598263

# Part 2

labels = input.split('').map(&:to_i)
labels.concat((labels.length + 1 .. 1_000_000).to_a)

one_cup = play.(labels, 10_000_000)
result_2 = one_cup.next.label * one_cup.next.next.label

puts result_2 # 248009574232
