require 'set'

class Set
  def pop
    value = @hash.each { |key, value| break key }
    @hash.delete(value)
    value
  end
end
