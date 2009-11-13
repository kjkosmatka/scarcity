# This function is used to build the dag that is ultimately submitted for each
# dataset. In many simple cases this can be left untouched.  However, there
# is great flexibility here and you can build an arbitrarily complex dag for
# each of your datasets which can buy you satisfying fault tolerance in Condor.
# When building your dag you can assume a Dataset object will be passed to this
# fuction which is a struct like:
#     Dataset = Struct.new :source, :sink, :filenames, :uniq
# where 'source' is the source directory for the dataset, 'sink' is the run time
# directory, and 'filenames' is an array of input data file names. 'uniq' is
# just the basename of the dataset source directory, but can be used as a unique
# identifier for the dataset in most cases
def build_dag(dataset)
  
  Scarcity::Dagger.new do
    
    # use the job statement to create nodes
    job :head, 'null.submit'
    
    # jobs can take a block to specify dag configurations relevant to the node
    job :main, "main.submit" do
      pre 'prejob.rb'
      post 'postjob.rb'
      vars :args => "command line args",
           :exec => "<%= base_name %>.rb",
           :inputfiles => dataset.filenames.join(',')
      priority 5
      retries 3
    end

    job :tail, 'null.submit'
    
    # breed parent nodes to define child nodes
    breed :head,   :children => :main
    breed :main,   :children => :tail

  end
  
end
