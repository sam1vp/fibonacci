require 'rspec'

describe Fixnum do 
  it "should return the closest lower fibonacci when sent closest_fibonacci" do
    156.closest_fibonacci.should == 144
    99.closest_fibonacci.should == 89
  end

  it "should return itself if it's a member of fibonacci and is sent closest_fibonacci" do 
    144.closest_fibonacci.should == 144
  end
  
  it "should return 0 or 1 if 0 or 1 (respectively) are sent closest_fibonacci" do 
    0.closest_fibonacci.should == 0
    1.closest_fibonacci.should == 1
  end

  it "should return self if self is negative" do 
    -5.closest_fibonacci.should == -5
  end

end

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

