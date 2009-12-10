module Scarcity

  class Submission
  
    attr_reader :datasets, :provision, :segment_directory, :data_directory
  
    def initialize(options={}, &block)
      @datasets = Array.new
      @provisions = Scarcity::Provisions::Core.new
      self.instance_eval(&block)
      fulfill if options[:fulfill]
    end
  
    def runs_in(directory)
      @segment_directory = directory
      @provisions.to directory
    end
  
    def pulls_from(directory, opts={})
      opts = {:only => nil, :except => nil}.merge(opts)
      @whitelist, @blacklist = opts[:only], opts[:except]
      @data_directory = directory
      @provisions.from directory
    end
  
    def provides(options, &block)
      options = {:from => @data_directory, :to => :each_dataset}.merge(options)
      if options[:to] == :each_dataset
        @datasets.each do |d|
          @provisions.context({:from => options[:from], :to => d.sink}, &block)
        end
      elsif options[:to] == :segment
        @provisions.context({:from => options[:from], :to => @segment_directory}, &block)
      else
        @provisions.context({:from => options[:from], :to => options[:to]}, &block)
      end
    end
    
    def fulfill
      @provisions.fulfill
    end
    
    def show_provisions
      @provisions.manifest.each do |action|
        puts "#{action.origin} >>> #{action.insertion}"
      end
    end
    
    def gathers_provisions(options={:zip_data => false})
      datadirs = Set.new(Dir.directories(@data_directory))
      datadirs &= @whitelist if @whitelist
      datadirs -= @blacklist if @blacklist
      
      datadirs.each do |dir|
        source = File.join(@data_directory, dir)
        sink = File.join(@segment_directory, dir)
        files = Dir.files(source)
        d = Dataset.new(source, sink, files, dir)
        if options[:zip_data]
          @provisions.context({:to => sink}) do
            archive dir
          end
        else
          @provisions.context({:from => d.source, :to => d.sink}) do
            files d.filenames
          end
        end
        @datasets << d
      end
    end
  
  end

end