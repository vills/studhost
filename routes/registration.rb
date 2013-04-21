#!/usr/bin/env ruby
#coding: UTF-8

get '/registration' do
  @faculties = Faculty.all(:order=>[:title.asc])
  haml :'registration/main', :layout=>:layout_registration
end

post '/registration' do
  @validate_hash = Helpers::random_string(32)
  @student = Speciality.get(params['speciality']).students.new(
                                                                  :name=>params['name'].strip,
                                                                  :email=>params['email'].strip,
                                                                  :password=>params['password'],
                                                                  :emailapprhash=>@validate_hash
                                                                  )
  pp @student
  if @student.save
    @msg = "Для подтверждения своего почтового ящика перейдите по ссылке: http://#{APP_CONFIG['domain']}/registration/validate/#{@validate_hash}"
    send_email "#{params['email'].strip}", :subject=>"Подтверждение почтового адреса", :body=>@msg
    puts @msg
    haml :'registration/accept', :layout=>:layout_registration
  else
    haml :'registration/fail', :layout=>:layout_registration
  end
end


get '/registration/validate/:key' do
  @s = Student.first(:emailapprhash=>"#{params['key']}")
  if @s.nil?
    haml :'registration/validation_bad', :layout=>:layout_registration
  else
    pp @s
    @s.update!(:emailappr=>true, :emailapprhash=>'')
    pp @s
    haml :'registration/validation_good', :layout=>:layout_registration
  end
end


# AJAX requests
get '/registration/specialities-list/:id' do
  content_type :json
  @f = Faculty.get(params['id'])
  @f.specialities.to_json
end