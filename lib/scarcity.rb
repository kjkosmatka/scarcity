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