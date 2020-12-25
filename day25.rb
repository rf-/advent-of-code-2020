require './shared'

public_keys = File.read('day25.input').strip.lines.map(&:to_i)

transform_step = -> (value, subject) do
  (value * subject) % 20201227
end

transform = -> (subject, loop_size) do
  value = 1
  loop_size.times do
    value = transform_step.(value, subject)
  end
  value
end

loop_size = -> (public_key) do
  value = 1
  (1..).each do |n|
    value = transform_step.(value, 7)
    return n if value == public_key
  end
end

loop_sizes = public_keys.map(&loop_size)
encryption_keys = public_keys.zip(loop_sizes.reverse).map { transform.(_1, _2) }
raise unless encryption_keys[0] == encryption_keys[1]

puts encryption_keys[0]
