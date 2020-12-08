require 'active_support/all'
require 'pp'
require 'pry'
require 'set'
require './lib/extensions'

INPUT = File.read('day8.input').strip.lines.map(&:chomp)

initial_program = INPUT.map do |line|
  op, arg = line.split(' ')
  [op, arg.to_i]
end

# Part 1

run_program = -> (program) do
  seen = Set.new
  acc, ptr = 0, 0

  loop do
    break [acc, seen] if seen.include?(ptr) || ptr == program.length
    seen.add(ptr)

    op, arg = program[ptr]
    case op
    when 'acc'
      acc += arg
      ptr += 1
    when 'jmp'
      ptr += arg
    when 'nop'
      ptr += 1
    end
  end
end

result_1, instructions_run = run_program.(initial_program)

puts result_1 # 1814

# Part 2

find_bad_ptr = -> (program) do
  pending = [program.length].to_set

  while pending.any?
    destination = pending.pop

    program.each_with_index do |(op, arg), ptr|
      points_to = ptr + arg == destination
      precedes = ptr + 1 == destination

      if (
        instructions_run.include?(ptr) &&
        (op == 'nop' && points_to || op == 'jmp' && precedes)
      )
        return ptr, op
      end

      if op == 'jmp' && points_to || (op == 'nop' || op == 'acc') && precedes
        pending.add(ptr)
      end
    end
  end
end

bad_ptr, bad_ptr_op = find_bad_ptr.(initial_program)

fixed_program = initial_program.deep_dup
fixed_program[bad_ptr][0] = bad_ptr_op == 'nop' ? 'jmp' : 'nop'

result_2, = run_program.(fixed_program)

puts result_2 # 1056
