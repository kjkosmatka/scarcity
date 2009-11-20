module Scarcity

  class Segment
    
    attr_reader :directory, :name, :datasets
    
    def initialize(directory)
      @directory = directory
      @name = File.basename(directory)
      @datasets = directories_in(@directory).sort.map { |data_id| SegmentDataset.new("#{directory}/#{data_id}") }
    end
    def directories_in(dir)
      items_in(dir).reject { |f| not File.directory?("#{dir}/#{f}") }
    end
    def files_in(dir)
      items_in(dir).reject { |f| File.directory?("#{dir}/#{f}") }
    end
    def items_in(dir)
      File.directory?(dir) ? Dir.entries(dir).reject { |f| f =~ /^\./ } : Array.new
    end
    
  end


  class SegmentDataset
    attr_reader :directory, :data_id
    def initialize(directory)
      @directory = directory
      @data_id = File.basename(directory)
    end
    def status
      stat = :unavailable
      if File.directory?(@directory)
        stat = :provisioned
        if File.exist?("#{@directory}/#{@data_id}.dag.dagman.log")
          stat = DagLog.new("#{@directory}/#{@data_id}.dag.dagman.log").status
        end
      end
      return stat
    end
  end

  
end