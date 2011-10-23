require 'rspec'

describe Fixnum do 
  it "should return the closest lower fibonacci when sent closest_fibonacci" do
    156.closest_fibonacci.should == 144
    99.closest_fibonacci.should == 89
  end
end

class Fixnum
  def closest_fibonacci(low = 0, high = 1)
    new_number = low + high
    return new_number if new_number + high > self
    closest_fibonacci(high, new_number)
  end
end

