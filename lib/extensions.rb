require 'set'

class Set
  def pop
    return if @hash.empty?
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

module Enumerable
  # Via https://gist.github.com/havenwood/27a5850b99bb35f855b079038664b120
  def find_map
    return enum_for __method__ unless block_given?

    each do |item|
      found = yield item
      return found if found
    end

    nil
  end
end

class Proc
  def memoize
    cache = {}
    old_call = method(:call)

    singleton_class.define_method :call do |*args, **kwargs|
      if cache.key?([args, kwargs])
        cache[[args, kwargs]]
      else
        value = old_call.call(*args, **kwargs)
        cache[[args, kwargs]] = value
        value
      end
    end

    singleton_class.define_method :clear do
      cache = {}
    end

    self
  end
end
