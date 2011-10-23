$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'fibonacci'

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
