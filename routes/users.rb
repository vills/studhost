#!/usr/bin/env ruby
#coding: UTF-8

get '/users/groups' do
  @groups = Group.all(:order=>[:title.asc])
  haml :users
end


get '/users/groups/add' do
  @title  = "Добавление группы пользователей"
  @action = "add"
  haml :users_edit
end

post '/users/groups/add' do
  g = Group.create(:title=>params['gname'])
  redirect '/users/groups'
end


get '/users/groups/edit/:id' do
  @g = Group.get(params['id'])
  if @g.nil? 
    @message = "Нет группы с таким номером"
    haml :send_message
  else
    @title  = "Редактирование группы пользователей"
    @action = "add"
    haml :users_edit
  end
end

post '/users/groups/edit/:id' do
  @g = Group.get(params['id'])
  if @g.nil? 
    @message = "Неверный запрос"
    haml :send_message
  else
    @g.update(:title=>params['gname'])
    redirect '/users/groups'
  end
end


get '/users/groups/delete/:id' do
  @g = Group.get(params['id'])
  @g.destroy
  redirect '/users/groups'
end