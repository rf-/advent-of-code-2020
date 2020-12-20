require './shared'

input = File.read('day18.input').strip.lines.map(&:chomp)

class Integer
  def -(other)
    self * other
  end

  def /(other)
    self + other
  end
end

# Part 1

puts input.map { eval(_1.tr('*', '-')) }.sum # 25190263477788

# Part 2

puts input.map { eval(_1.tr('+*', '/-')) }.sum # 297139939002972
