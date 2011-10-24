class Fixnum
  def closest_fibonacci
    recurse_to_closest_fibonacci
  end

  private

  def recurse_to_closest_fibonacci(low = 0, high = 1)
    return self if self <= 0
    if low + high > self   #next number is going to be too large
      return high    #all done!
    else 
      return recurse_to_closest_fibonacci(high, low + high)    #head further down the stack (http://bit.ly/dAx3tT)
    end
  end

end

