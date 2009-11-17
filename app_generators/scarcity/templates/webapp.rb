require 'rubygems'
require 'sinatra'
require 'config/environment'

helpers do
  def directories_in(dir)
    File.directory?(dir) ? Dir.entries(dir).reject { |f| f =~ /^\./ or not File.directory?("#{dir}/#{f}") } : Array.new
  end
  def files_in(dir)
    File.directory?(dir) ? Dir.entries(dir).reject { |f| f =~ /^\./ or File.directory?("#{dir}/#{f}") } : Array.new
  end
  def items_in(dir)
    File.directory?(dir) ? Dir.entries(dir).reject { |f| f =~ /^\./ } : Array.new
  end
end

before do
  @app_name = APP_NAME
  @data_dir = DATA_DIR
  @runs_dir = RUNS_DIR
end


get '/' do
  @data_ids = directories_in(DATA_DIR).sort
  @segments = directories_in(RUNS_DIR).sort
  erb :index
end

get '/segments/:segment' do
  @segment = params[:segment]
  @data_ids = directories_in("#{RUNS_DIR}/#{@segment}").sort
  erb :segment
end

get '/documentation' do
  erb :documentation
end
