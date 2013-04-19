#!/usr/bin/env ruby
#coding: UTF-8

get '/' do
  haml :index
end

not_found do
  @message = "Страница не найдена"
  haml :send_message
end