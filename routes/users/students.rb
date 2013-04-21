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
      @u = @s.students.all(:approved=>true, :order=>[:name.asc])
      haml :'users/students', :layout=>:layout_admin
    end
  end
end


