require 'test_helper'

class TestDagger < Test::Unit::TestCase
  def setup
    @d = Scarcity::Dagger.new do
      job :head, 'head.submit', :dir => 'some/other/directory' do
        priority 5
        retries 3
      end
    end
  end
  
  def test_save
    @d.save('test.dag')
  end

end