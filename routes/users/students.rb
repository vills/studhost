#!/usr/bin/env ruby
#coding: UTF-8

get '/users/faculties/:id/specialities/:sid/students' do
  @f = Faculty.get(params['id'])
  if @f.nil?
    @message = "Нет такого факультета"
    haml :send_message
  else
    @s = @f.specialities.get(params['sid'])
    if @s.nil?
      @message = "Нет такой специальности"
      haml :send_message
    else
      @u = @s.students.all(:order=>[:name.asc])
      haml :'users/students'
    end
  end
end

=begin
get '/users/faculties/:id/specialities' do
  @f = Faculty.get(params['id'])
  if @f.nil?
    @message = "Нет такого факультета"
    haml :send_message
  end

  @s = @f.specialities.all(:order=>[:title.asc])
  haml :'users/specialities'
end

post '/users/faculties/:id/specialities/add' do
  @f = Faculty.get(params['id'])
  if @f.nil?
    @message = "Нет такого факультета"
    haml :send_message
  else
    @f.specialities.create(:title=>params['title'])
    redirect "/users/faculties/#{params['id']}/specialities"
  end
end

post '/users/faculties/:id/specialities/:sid/edit' do
  @s = Speciality.get(params['sid'])
  if @s.nil? 
    @message = "Нет такой специальности"
    haml :send_message
  else
    @s.update(:title=>params['title'])
    redirect "/users/faculties/#{params['id']}/specialities"
  end
end

get '/users/faculties/:id/specialities/:sid/delete' do
  @g = Speciality.get(params['sid'])
  @g.destroy
  redirect "/users/faculties/#{params['id']}/specialities"
end
=end

