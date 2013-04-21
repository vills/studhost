require 'rubygems'
require 'sinatra'

set :environment, :production

require './app.rb'

run Sinatra::Application