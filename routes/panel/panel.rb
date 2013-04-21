#!/usr/bin/env ruby
#coding: UTF-8

before '/panel*' do
  @student = session[:user]
end

get '/panel' do

  haml :'panel/index', :layout=>:layout_panel
end


