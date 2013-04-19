require 'rubygems'
require 'sinatra'

set :environment, :production

require './outside.rb'

run Sinatra::Application