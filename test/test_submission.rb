require 'test_helper'

class TestSubmission < Test::Unit::TestCase
  def setup
    segsdir = '/Data/home/kris/Desktop/segments'
    datadir = '/Data/home/kris/Desktop/datasets'
    
    @sub = Scarcity::Submission.new do
      runs_in     segsdir
      pulls_from  datadir,
        :only => ['alz0001','alz0002','alz0003','alz0004','alz0005','alz0006'],
        :except => ['alz0003','alz0004']
      gathers_provisions :zip_data => true
      
      provides :from => '../lib/scarcity', :to => :each_dataset do
        file 'submission.rb', :chmod => 0755
      end
      
      provides :from => '..', :to => :segment do
        file 'Rakefile', :collision => :replace
      end
      
      provides :from => '..', :to => '/Data/home/kris/Desktop' do
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
