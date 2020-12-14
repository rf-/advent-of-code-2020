require 'set'

class Set
  def pop
    value = @hash.each { |key, value| break key }
    @hash.delete(value)
    value
  end
end

class Array
  # Generate all combinations of any length (including 0)
  def all_combinations
    (0...2 ** length).map do |mask|
      idx = 0
      result = []
      while mask > 0
        result << self[idx] if mask & 1 == 1
        idx += 1
        mask >>= 1
      end
      result
    end
  end
end
