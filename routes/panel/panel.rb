#!/usr/bin/env ruby
#coding: UTF-8

get '/panel' do
  haml :'panel/index', :layout=>:layout_panel
end


