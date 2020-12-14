require './shared'

instructions = File.read('day14.input').strip.lines.map do |line|
  if line =~ /^mask = (.*)$/
    ['mask', $1]
  elsif line =~ /^mem\[(\d+)\] = (\d+)$/
    ['mem', $1.to_i, $2.to_i]
  else
    raise line
  end
end

encode_value = -> (value) { value.to_s(2).rjust(36, '0') }

# Part 1

mask = nil
memory = {}

instructions.each do |inst, arg1, arg2|
  mask = arg1 and next if inst == 'mask'

  address, value = arg1, arg2
  masked_value = encode_value.(value).chars.zip(mask.chars)
    .map { |vc, mc| mc == 'X' ? vc : mc }
    .join('')
    .to_i(2)

  memory[address] = masked_value
end

result_1 = memory.values.sum

puts result_1 # 13556564111697

# Part 2

mask = nil
memory = {}

instructions.each do |inst, arg1, arg2|
  mask = arg1 and next if inst == 'mask'

  address, value = arg1, arg2
  masked_address = encode_value.(address).chars.zip(mask.chars)
    .map { |ac, mc| mc == 'X' ? 'X' : mc == '1' ? '1' : ac }
    .join('')

  base_address = masked_address.tr('X', '0').to_i(2)
  address_offsets = masked_address.chars.reverse
    .each_with_index
    .filter_map { |c, i| 1 << i if c == 'X' }

  address_offsets.all_combinations.each do |offsets|
    memory[base_address + offsets.sum] = value
  end
end

result_2 = memory.values.sum

puts result_2 # 4173715962894
