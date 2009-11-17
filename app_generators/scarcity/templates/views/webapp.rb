require 'rubygems'
require 'sinatra'
require 'config/environment'

helpers do
  def directories_in(dir)
    items_in(dir).reject { |f| not File.directory?("#{dir}/#{f}") }
  end
  def files_in(dir)
    items_in(dir).reject { |f| File.directory?("#{dir}/#{f}") }
  end
  def items_in(dir)
    File.directory?(dir) ? Dir.entries(dir).reject { |f| f =~ /^\./ } : Array.new
  end
  def tab_content(active_tab, tab)
    active_tab == tab ? "<p>#{tab}</p>" : "<a href='/#{tab}'>#{tab}</a>"
  end
end

before do
  @app_name = APP_NAME
  @data_dir = DATA_DIR
  @runs_dir = RUNS_DIR
end


get %r{/$|/home$} do
  @active_tab = :home
  @data_ids = directories_in(DATA_DIR).sort
  @segments = directories_in(RUNS_DIR).sort
  erb :index
end

get '/segments' do
  @active_tab = :segments
  @segments = directories_in(RUNS_DIR).sort
  erb :segments
end

get '/segments/:segment' do
  @active_tab = :segments
  @segment = params[:segment]
  @data_ids = directories_in("#{RUNS_DIR}/#{@segment}").sort
  erb :segment
end

get '/data' do
  @active_tab = :data
  @data_ids = directories_in(DATA_DIR).sort
  erb :data
end

get '/documentation' do
  @active_tab = :documentation
  erb :documentation
end
