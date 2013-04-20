#!/usr/bin/env ruby
#coding: UTF-8

require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'pp'

# include models
require 'data_mapper'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/#{Sinatra::Application.environment}.sqlite")
DataMapper::Logger.new(STDOUT, :debug)
Dir[Dir.pwd + "/models/*.rb"].each { |f| require f }
DataMapper.finalize

# setting view engine
set :haml, :format => :html5
def render_file(filename)
  contents = File.read(filename)
  Haml::Engine.new(contents).render
end


# include routes
Dir[Dir.pwd + "/routes/*.rb"].each { |f| load f }
Dir[Dir.pwd + "/routes/*/*.rb"].each { |f| load f }