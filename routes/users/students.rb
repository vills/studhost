#!/usr/bin/env ruby
#coding: UTF-8

get '/admin/users/faculties/:id/specialities/:sid/students' do
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
      haml :'users/students', :layout=>:layout_admin
    end
  end
end

=begin
get '/admin/users/faculties/:id/specialities' do
  @f = Faculty.get(params['id'])
  if @f.nil?
    @message = "Нет такого факультета"
    haml :send_message
  end

  @s = @f.specialities.all(:order=>[:title.asc])
  haml :'users/specialities'
end

post '/admin/users/faculties/:id/specialities/add' do
  @f = Faculty.get(params['id'])
  if @f.nil?
    @message = "Нет такого факультета"
    haml :send_message
  else
    @f.specialities.create(:title=>params['title'])
    redirect "/admin/users/faculties/#{params['id']}/specialities"
  end
end

post '/admin/users/faculties/:id/specialities/:sid/edit' do
  @s = Speciality.get(params['sid'])
  if @s.nil? 
    @message = "Нет такой специальности"
    haml :send_message
  else
    @s.update(:title=>params['title'])
    redirect "/admin/users/faculties/#{params['id']}/specialities"
  end
end

get '/admin/users/faculties/:id/specialities/:sid/delete' do
  @g = Speciality.get(params['sid'])
  @g.destroy
  redirect "/admin/users/faculties/#{params['id']}/specialities"
end
=end

