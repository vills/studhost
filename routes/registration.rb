#!/usr/bin/env ruby
#coding: UTF-8

get '/registration' do
  if Student.count < 1
    @faculties = Faculty.all
  else
    @faculties = Faculty.all(:order=>[:title.asc], :id.gt=>1)
  end
  haml :'registration/main', :layout=>:layout_registration
end

post '/registration' do
  @validate_hash = Helpers::random_string(32)
  @is_admin = false
  @approved = false

  adminreg = Student.all.count < 1 ? 1 : 0
  if adminreg > 0
    @is_admin = true
    @approved = true
  end
  
  @student = Speciality.get(params['speciality']).students.new(
                                                                  :name=>params['name'].strip,
                                                                  :email=>params['email'].strip,
                                                                  :password=>params['password'],
                                                                  :emailapprhash=>@validate_hash,
                                                                  :is_admin=>@is_admin,
                                                                  :approved=>@approved
                                                                  )
  if @student.save
    if adminreg < 1
      @msg = "Для подтверждения своего почтового ящика перейдите по ссылке: http://#{APP_CONFIG['domain']}/registration/validate/#{@validate_hash}"
      send_email "#{params['email'].strip}", :subject=>"Подтверждение почтового адреса", :body=>@msg
      haml :'registration/accept', :layout=>:layout_registration
    else
      `sudo /usr/local/bin/studhosting-user-create.sh '#{@student.username}'`
      redirect '/'
    end
  else
    haml :'registration/fail', :layout=>:layout_registration
  end
end


get '/registration/validate/:key' do
  @s = Student.first(:emailapprhash=>"#{params['key']}")
  if @s.nil?
    haml :'registration/validation_bad', :layout=>:layout_registration
  else
    @s.update!(:emailappr=>true, :emailapprhash=>'')
    haml :'registration/validation_good', :layout=>:layout_registration
  end
end


# AJAX requests
get '/registration/specialities-list/:id' do
  content_type :json
  @f = Faculty.get(params['id'])
  @f.specialities.to_json
end