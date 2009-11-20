# ruby core
require 'rubygems'
require 'ftools'
require 'fileutils'
require 'yaml'

# vendor gems
# require 'sinatra'

# local gems
require 'scarcity'

# application configs
require 'config/environment.rb'
require 'config/builders/dag_builder.rb'
require 'config/builders/provisions_builder.rb'
RETURN_CODES = ReturnCodes.new(YAML::load(File.open('config/return_codes.yml')))


# boot time validations
def validate_environment
  must_have_data_source_certificate(DATA_DIR)
end

def must_have_data_source_certificate(directory)
  if not File.exist?(directory + '/.scarcity_data_certificate')
    puts "Cannot start <%= base_name %>: missing certificate in the data source directory"
    puts "Create one now if you wish:"
    puts "\ttouch #{DATA_DIR}/.scarcity_data_certificate"
    exit
  end
end

# all that for this
validate_environment