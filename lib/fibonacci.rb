class Fixnum
  def closest_fibonacci
    next_fib_number
  end

  private

  def next_fib_number(low = 0, high = 1)
    return self if [0,1].include?(self) or self < 0
    new_number = low + high
    return new_number if new_number + high > self
    next_fib_number(high, new_number)
  end
end

