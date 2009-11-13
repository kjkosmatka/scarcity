require 'helper'

class TestSubmission < Test::Unit::TestCase
  def setup
    rundir = '/Users/kosmatka/Desktop/runs'
    
    
    @sub = Scarcity::Submission.new do
      runs_in rundir
      pulls_from '/Users/kosmatka/Desktop/datasets',
        :only => '123456'.each_char.to_a,
        :except => ['3','4']
      gathers_provisions
      
      provides :from => '../lib/scarcity', :to => :each_dataset do
        file 'submission.rb', :chmod => 0755
      end
      
      provides :from => '..', :to => :run do
        file 'Rakefile', :collision => :replace
      end
      
      provides :from => '..', :to => '/Users/kosmatka/Desktop' do
        file 'Rakefile', :as => 'boo.txt'
      end
    end
    
    
  end
  
  def test_fulfill
    @sub.fulfill
  end
  
  # def test_show_provisions
  #   @sub.show_provisions
  # end
end
