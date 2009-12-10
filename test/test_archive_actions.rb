require 'test_helper'

class TestArchiveActions < Test::Unit::TestCase
  
  DATA_DIR = '/Data/home/kris/Desktop/datasets'
  SEGMENTS_DIR = '/Data/home/kris/Desktop/segments'
  
  def setup
    
    @prov = Scarcity::Provisions::Core.new do
      
      from  DATA_DIR
      to    SEGMENTS_DIR
      
      archive 'alz0000', :as => 'bladdow.tar.gz'
      
    end
    
  end
  
  def test_fulfillment
    @prov.fulfill
  end
  
end