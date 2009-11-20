require 'test_helper'

class TestReturnCodes < Test::Unit::TestCase
  def setup
    @rc = ReturnCodes.new({0 => 'zero', 1 => 'one', 'code_missing' => 'the code is missing', 'pending' => 'it is pending'})
  end
  
  def test_init
    puts @rc.message(0)
    puts @rc.message(1)
    puts @rc.message(99)
    puts @rc.message(nil)
  end
end