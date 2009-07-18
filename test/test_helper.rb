require File.expand_path(File.dirname(__FILE__) + "/../biki")
require 'bacon'
require 'facon'
require 'sinatra/test'

set :environment, :test

class Bacon::Context
  include Sinatra::Test
end
