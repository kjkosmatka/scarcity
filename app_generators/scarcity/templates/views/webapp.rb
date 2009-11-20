require 'rubygems'
require 'sinatra'
require 'config/boot'

helpers do
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
  @data_ids = Dir.directories(DATA_DIR).sort
  @segments = Dir.directories(RUNS_DIR).sort
  erb :index
end

get '/segments' do
  @active_tab = :segments
  @segments = Dir.directories(RUNS_DIR).sort
  erb :segments
end

get '/segments/:segment' do
  @active_tab = :segments
  @segment = Scarcity::Segment.new("#{RUNS_DIR}/#{params[:segment]}")
  erb :segment
end

get '/data' do
  @active_tab = :data
  @data_ids = Dir.directories(DATA_DIR).sort
  erb :data
end

get '/documentation' do
  @active_tab = :documentation
  erb :documentation
end

get '/configuration' do
  @active_tab = :configuration
  erb :configuration
end
