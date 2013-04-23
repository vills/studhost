#!/usr/bin/env ruby
#coding: UTF-8


before '/admin*' do
  protected!
end


get '/' do
  haml :index
end

get '/admin' do
  @notApprovedStudents = Student.all(:emailappr=>true, :approved=>false)
  haml :"admin/index", :layout=>:layout_admin
end


not_found do
  @message = "Страница не найдена"
  haml :send_message
end