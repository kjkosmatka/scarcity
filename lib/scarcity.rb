$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'set'
require 'fileutils'
libpath = File.dirname(__FILE__) + '/scarcity'
require libpath + '/submission'
require libpath + '/segment'
require libpath + '/dagger'
require libpath + '/provisions/core'
require libpath + '/provisions/actions'


module Scarcity
  Dataset = Struct.new :source, :sink, :filenames, :uniq
  VERSION = '0.0.1'
  
  module Provisions
  end
  
end

class Dir
  def self.directories(dir)
    self.items(dir).reject { |f| not File.directory?("#{dir}/#{f}") }
  end
  def self.files(dir)
    self.items(dir).reject { |f| File.directory?("#{dir}/#{f}") }
  end
  def self.items(dir)
    File.directory?(dir) ? Dir.entries(dir).reject { |f| f =~ /^\./ } : Array.new
  end
end

class ReturnCodes
  CODE_MISSING = 'code_missing'
  PENDING = 'pending'
  def initialize(code_hash)
    @coded_messages = code_hash
  end
  def message(code)
    if code.nil? or code == ''
      code = PENDING
    elsif not @coded_messages.has_key?(code)
      code = CODE_MISSING
    end
    @coded_messages[code]
  end
end