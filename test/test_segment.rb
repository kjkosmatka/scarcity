require 'test_helper'

class TestSegment < Test::Unit::TestCase
  
  def setup
    @seg = Scarcity::Segment.new('/Data/home/kris/Desktop/segments/trial-run-kjk')
  end
  
  def test_something
    @seg.datasets.each { |d| puts d.status }
  end
  
end