require 'rubygems'
require 'sinatra'
require 'haml'
require 'bluecloth'

$:.push File.expand_path(File.dirname(__FILE__))
require 'biki_helper.rb'

get '/' do
  haml :index
end

get '/release' do
  haml :release
end

get '/asset' do
  haml :asset
end

get '/css/:file.css' do |file|
  content_type 'text/css', :charset => 'utf-8'
  sass file.to_sym
end
