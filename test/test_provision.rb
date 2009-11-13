require 'test_helper'

class TestProvision < Test::Unit::TestCase
  def setup
    rundir = '/Users/kosmatka/Desktop/runs'
    @prov = Scarcity::Provisions::Core.new do
      from '../lib/scarcity'
      to rundir
      
      file 'dagger.rb', :as => 'outprovision.rb'
      file 'submission.rb', :chmod => 0755, :overwrite => true
      
      from '..' do
        file 'README.rdoc'
        file 'Rakefile', :as => 'wastherakefile'
      end
      
      to rundir + '/subdir' do
        file 'submission.rb', :as => 'gompgomp.rb'
      end
      
    end
  end
  
  def test_empty_initialization
    Scarcity::Provisions::Core.new
  end
  
  def test_empty_initialization_with_fulfill
    Scarcity::Provisions::Core.new :fulfill => true do
      from '../lib/scarcity'
      to '/Users/kosmatka/Desktop'
    end
  end
  
  def test_adding_to_manifest_without_context
    Scarcity::Provisions::Core.new do
      file 'some_file.txt'
    end
  end
  
  def test_manifest_blocks
    p = Scarcity::Provisions::Core.new
    p.manifest do
      from '../lib/scarcity'
      to '/Users/kosmatka/Desktop/runs/'
      file 'submission.rb', :as => 'dummy.rb'
    end
  end
  
  def test_fulfillment
    @prov.fulfill
  end
end