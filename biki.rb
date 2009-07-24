require 'rubygems'
require 'sinatra'
require 'haml'
require 'bluecloth'

$:.push File.expand_path(File.dirname(__FILE__))
load 'biki_helper.rb'

before do
  @pages = Page.recent_page_names
  @tags  = Page.all_tag_names
end

get '/' do
  @page = Page.load(@pages.first || 'home')
  haml :page
end

get '/css/:file.css' do |file|
  content_type 'text/css', :charset => 'utf-8'
  sass file.to_sym
end

get '/pages' do
  haml :pages
end

get '/tags' do
  haml :tags
end

get '/tag/:tag_name' do |tag_name|
  @page = nil
  @tag_name = tag_name
  @tagstable = Page.map_pages_to_tags
  haml :tag
end


get '/:page_name' do |page_name|
  @page = Page.load page_name
  haml :page
end

get '/:page_name/edit' do |page_name|
  @page = Page.load page_name
  haml :edit
end

post '/:page_name' do |page_name|
  @page = Page.load page_name
  @page.content = params[:content]
  @page.tags_as_string = params[:tags_as_string]
  @page.save
  redirect "/#{page_name}"
end
