#!/usr/bin/env ruby
#coding: UTF-8

get '/login' do
  haml :'panel/login.haml', :layout=>:layout_panel
end

post '/login' do
  if session[:user] = Student.authenticate(params["email"], params["password"])
    flash("Login successful")
    redirect '/'
  else
    flash("Login failed - Try again")
    redirect '/user/login'
  end
end