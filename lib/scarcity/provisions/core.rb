module Scarcity
module Provisions
  
  class Core
    
    attr_reader :from, :to, :manifest
    
    def initialize(options={}, &block)
      options = {:from => nil, :to => nil, :fulfill => false}.merge(options)
      @from, @to = options[:from], options[:to]
      @manifest = Array.new
      instance_eval(&block) if block_given?
      fulfill if options[:fulfill]
    end
    
    def manifest_update(&block)
      instance_eval(&block) if block_given?
    end
    
    def context(options, &block)
      oldfrom, oldto = @from, @to
      options = {:from => @from, :to => @to}.merge(options)
      @from, @to = options[:from], options[:to]
      instance_eval(&block) if block_given?
      @from, @to = oldfrom, oldto
    end
    
    def from(directory, &block)
      if block_given?
        context({:from => directory}, &block)
      else
        @from = directory
      end
    end
    
    def to(directory, &block)
      if block_given?
        context({:to => directory}, &block)
      else
        @to = directory
      end
    end
    
    def archive(directory,options={})
      defaults = { :from => @from,
                   :item => directory,
                   :to => @to }
      options = defaults.merge(options)
      @manifest << ArchiveAction.new(options)
    end
    
    def file(filename,options={})
      defaults = { :from => @from,
                   :item => filename,
                   :to => @to }
      options = defaults.merge(options)
      @manifest << FileAction.new(options)
    end
    
    def files(filelist,options={})
      filelist.each do |filename|
        file(filename,options)
      end
    end
    
    def fulfill
      @manifest.each do |action|
        action.fulfill
      end
    end
    
  end
  
end
end