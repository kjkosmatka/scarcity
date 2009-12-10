module Scarcity
module Provisions
  
  MESSAGE_FORMAT = "%12s   %s"
  
  class FileAction
    
    attr_accessor :from, :filename, :to, :as, :chmod, :collision
    
    def initialize(options)
      defaults = { :from => nil, 
                   :filename => nil,
                   :to => nil, 
                   :as => nil, 
                   :chmod => nil, 
                   :collision => :skip }
      options = defaults.merge(options)
      defaults.keys.each do |k|
        instance_variable_set "@#{k}", "#{options[k]}"
      end
      # ensure chmod is an int not a string
      @chmod = options[:chmod]
      @collision = options[:collision]
    end
    
    def origin
      # "#{from}/#{filename}"
      File.join(from,filename)
    end
    
    def insertion
      # "#{to}/#{as}"
      File.join(to,as)
    end
    
    def fulfill
      if not File.exist?(origin)
        puts MESSAGE_FORMAT % ["absent", @filename]
        return
      end
      
      if not File.directory?(@to)
        puts MESSAGE_FORMAT % ["create", @to]
        FileUtils.mkdir_p @to
      end
      
      if File.exist?(insertion)
        if @collision == :replace
          puts MESSAGE_FORMAT % ["replace", @as]
          FileUtils.cp origin, insertion
          FileUtils.chmod @chmod, insertion if @chmod
        else
          puts MESSAGE_FORMAT % ["exists", @as]
        end
      else
        puts MESSAGE_FORMAT % ["create", insertion]
        FileUtils.cp origin, insertion
        FileUtils.chmod @chmod, insertion if @chmod
      end
    end
    
  end
  
  class ArchiveAction
    attr_accessor :from, :to, :collision
    def initialize(options)
      defaults = { :from => nil,
                   :to => nil,
                   :as => nil,
                   :collision => :skip }
      options = defaults.merge(options)
      defaults.keys.each do |k|
        instance_variable_set "@#{k}", "#{options[k]}"
      end
    end
    def fulfill
      if not File.directory?(@from)
        puts MESSAGE_FORMAT % ["absent", @from]
    end
  end
  
end
end