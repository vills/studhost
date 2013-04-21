#!/usr/bin/env ruby
#coding: UTF-8

get '/registration' do
  @faculties = Faculty.all(:order=>[:title.asc])
  haml :'registration/main', :layout=>:layout_registration
end

post '/registration' do
  @student = Speciality.get(params['speciality']).students.new(
                                                                  :name=>params['name'].strip,
                                                                  :email=>params['email'].strip,
                                                                  :password=>params['password']
                                                                  )
  if @student.save
    haml :'registration/accept', :layout=>:layout_registration
  else
    haml :'registration/fail', :layout=>:layout_registration
  end
end



# AJAX requests
get '/registration/specialities-list/:id' do
  content_type :json
  @f = Faculty.get(params['id'])
  @f.specialities.to_json
end