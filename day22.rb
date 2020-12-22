require './shared'

input = File.read('day22.input')
original_hands = input.split("\n\n").map { _1.lines.drop(1).map(&:to_i) }

game = -> (hands, recurse:) do
  seen_configurations = [].to_set

  while hands[0].length > 0 && hands[1].length > 0
    hash = hands.hash
    return 0 if seen_configurations.include?(hash)
    seen_configurations.add(hash)

    cards = hands.map(&:shift)
    winner =
      if recurse && hands[0].length >= cards[0] && hands[1].length >= cards[1]
        game.(hands.zip(cards).map { _1.first(_2) }, recurse: true)
      else
        cards[0] > cards[1] ? 0 : 1
      end

    if winner == 0
      hands[0].concat(cards)
    else
      hands[1].concat(cards.reverse)
    end
  end

  hands[0].length > 0 ? 0 : 1
end

score = -> (hand) do
  hand.reverse.map.with_index { |card, index| card * (index + 1) }.sum
end

# Part 1

hands = original_hands.deep_dup
winner = game.(hands, recurse: false)
result_1 = score.(hands[winner])

puts result_1 # 35818

# Part 2

hands = original_hands.deep_dup
winner = game.(hands, recurse: true)
result_2 = score.(hands[winner])

puts result_2 # 34771
