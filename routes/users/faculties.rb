#!/usr/bin/env ruby
#coding: UTF-8

get '/users/faculties' do
  @faculties = Faculty.all(:order=>[:title.asc])
  haml :'users/faculties'
end

post '/users/faculties/add' do
  g = Faculty.create(:title=>params['fname'])
  redirect '/users/faculties'
end

post '/users/faculties/:id/edit' do
  @f = Faculty.get(params['id'])
  if @f.nil? 
    @message = "Неверный запрос"
    haml :send_message
  else
    @f.update(:title=>params['fname'])
    redirect '/users/faculties'
  end
end

get '/users/faculties/:id/delete' do
  @g = Group.get(params['id'])
  @g.destroy
  redirect '/users/faculties'
end