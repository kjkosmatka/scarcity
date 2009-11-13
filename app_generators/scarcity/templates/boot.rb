# ruby core
require 'rubygems'
require 'ftools'
require 'fileutils'

# vendor gems
# require 'sinatra'

# local gems
require 'scarcity'

# application configs
require 'config/environment.rb'
require 'config/builders/dag_builder.rb'
require 'config/builders/provisions_builder.rb'


# boot time validations
def validate_environment
  must_have_data_source_certificate(DATA_DIR)
end

def must_have_data_source_certificate(directory)
  if not File.exist?(directory + '/.soar_data_certificate')
    puts "Cannot start <%= base_name %>: missing certificate in the data source directory"
    exit
  end
end

# all that for this
validate_environment