#!/usr/bin/env ruby
#coding: UTF-8

require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'pp'
require 'net/smtp'
require 'yaml'
require 'digest/md5'

set :bind, '0.0.0.0'
set :sessions => true

# loading config
APP_CONFIG = YAML.load( File.read(Dir.pwd + "/config.yml") )[ Sinatra::Application.environment.to_s ]
APP_CONFIG['ENV'] = Sinatra::Application.environment.to_s
pp APP_CONFIG
# include models
require 'data_mapper'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/#{Sinatra::Application.environment}.sqlite")
DataMapper::Logger.new(STDOUT, :debug)
Dir[Dir.pwd + "/models/*.rb"].each { |f| require f }
Dir[Dir.pwd + "/models/*/*.rb"].each { |f| require f }
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


# functions
def send_email(to,opts={})
  opts[:server]      ||= 'localhost'
  opts[:from]        ||= APP_CONFIG['emails']['robot']['email']
  opts[:from_alias]  ||= APP_CONFIG['emails']['robot']['name']
  opts[:subject]     ||= "Хостинг"
  opts[:body]        ||= ""

msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

  unless APP_CONFIG['ENV'] = "production"
    Net::SMTP.start(opts[:server]) do |smtp|
      smtp.send_message msg, opts[:from], to
    end
  end
end