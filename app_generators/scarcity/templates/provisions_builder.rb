# This function is used to provide resources to each dataset in its run time
# location on the submitting machine.  Providing all this to each dataset
# allows your submit description files and dags to have all they need in one 
# spot when submitting to the condor daemons
def build_provisions(run_directory, data_directory, whitelist, blacklist)
  
  Scarcity::Submission.new do
  
    # declare where runs happen and where data comes from
    # and indicate that we gather default provisions accordingly 
    # This will not need to change in almost all cases.
    runs_in         run_directory
    pulls_from      data_directory, :only => whitelist, :except => blacklist
    gathers_provisions :zip_data => true
  
    # Declare other goods that will be provided to each dataset at run time.
    provides :from => 'app/executables', :to => :each_dataset do
      file '<%= base_name %>.rb', :chmod => 0755
    end
  
    provides :from => 'app/scripts', :to => :each_dataset do
      file 'prejob.rb', :chmod => 0755
      file 'postjob.rb', :chmod => 0755
    end
  
    provides :from => 'app/submits', :to => :each_dataset do
      file '<%= base_name %>.submit'
    end
    
    provides :from => 'lib/submits', :to => :each_dataset do
      file 'null.submit'
    end
  
    # You might also declare goods to be provided to the segment as a whole
    # provides :from => 'lib/submits', :to => :segment do
    #   file 'null.submit'
    # end
  
  end
  
end