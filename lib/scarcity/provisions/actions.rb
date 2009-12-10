module Scarcity
module Provisions
  
  class ItemAction
    
    attr_accessor :from, :item, :to, :as, :collision
    MESSAGE_FORMAT = "%12s   %s"
    
    def initialize(options={})
      defaults = { :from => nil,        :to => nil,
                   :item => nil,        :as => options[:item],
                   :collision => :skip }
      options = defaults.merge(options)
      validates_options options
      options.each_pair do |k,v|
        instance_variable_set "@#{k}", v
      end
    end
    
    def validates_options(opts)
      opts.each do |opt|
        raise ArgumentError if opt.nil?
      end
    end
    
    def origin
      File.join(@from,@item)
    end
    
    def insertion
      File.join(@to,@as)
    end
    
    def fulfill
      if not File.exist?(origin)
        report "absent", @item
        return
      end
      
      if not File.directory?(@to)
        report "create", @to
        FileUtils.mkdir_p @to
      end
      
      if File.exist?(insertion)
        if @collision == :replace
          report "replace", @as
          replace_action
        else
          report "exists", @as
        end
      else
        report "create", insertion
        create_action
      end
    end
    
    def report(keyword, message)
      puts MESSAGE_FORMAT % [keyword, message]
    end
    
  end
  
  
  class FileAction < ItemAction
    def initialize(options={})
      super(options)
      @chmod = options[:chmod]
    end
    
    def replace_action
      create_action
    end
    
    def create_action
      FileUtils.cp origin, insertion
      FileUtils.chmod @chmod, insertion if @chmod
    end
  end
  
  
  class ArchiveAction < ItemAction
    def initialize(options={})
      super(options)
      @as += ".tar.gz" unless /\.tar\.gz$/ =~ @as
    end
    
    def archive
      Dir.chdir(origin) do
        manifest = Dir.glob('*').join(' ')
        system("tar -czf #{insertion} #{manifest}")
      end
    end
    
    def replace_action
      FileUtils.rm insertion
      archive
    end
    
    def create_action
      archive
    end
  end
  
  
end
end