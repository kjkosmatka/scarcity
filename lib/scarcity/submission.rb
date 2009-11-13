module Scarcity

  class Submission
  
    attr_reader :datasets, :provision, :run_directory, :data_directory
  
    def initialize(options={}, &block)
      @datasets = Array.new
      @provisions = Scarcity::Provisions::Core.new
      self.instance_eval(&block)
      fulfill if options[:fulfill]
    end
  
    def runs_in(directory)
      @run_directory = directory
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
      elsif options[:to] == :run
        @provisions.context({:from => options[:from], :to => @run_directory}, &block)
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
    
    def gathers_provisions
      datadirs = Set.new(directories_in(@data_directory))
      datadirs &= @whitelist if @whitelist
      datadirs -= @blacklist if @blacklist
      
      datadirs.each do |dir|  
        source = @data_directory + '/' + dir
        sink = @run_directory + '/' + dir
        files = visible_files_in(source)
        d = Dataset.new(source, sink, files, dir)
        @provisions.context({:from => d.source, :to => d.sink}) do
          files d.filenames
        end
        @datasets << d
      end
    end
  
  private
  
    def directories_in(directory)
      Dir.entries(directory).reject { |f| not File.directory?(directory + '/' + f) or /^\./ =~ f }
    end
  
    def visible_files_in(directory)
      Dir.entries(directory).reject { |f| File.directory?(directory + '/' + f) or /^\./ =~ f }
    end
  
  end

end