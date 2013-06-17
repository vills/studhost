#!/usr/bin/env ruby
#coding: UTF-8

get '/admin/users/faculties' do
  @faculties = Faculty.all(:order=>[:title.asc])
  haml :'users/faculties', :layout=>:layout_admin
end

post '/admin/users/faculties/add' do
  g = Faculty.create(:title=>params['fname'])
  redirect '/admin/users/faculties'
end

post '/admin/users/faculties/:id/edit' do
  @f = Faculty.get(params['id'])
  if @f.nil? 
    @message = "Неверный запрос"
    haml :send_message
  else
    @f.update(:title=>params['fname'])
    redirect '/admin/users/faculties'
  end
end

get '/admin/users/faculties/:id/delete' do
  @g = Faculty.get(params['id'])
  @g.destroy
  redirect '/admin/users/faculties'
end