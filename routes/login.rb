#!/usr/bin/env ruby
#coding: UTF-8

get '/login' do
  haml :'panel/login', :layout=>:layout_login
end

get '/login/retry' do
  @falselogin = true
  haml :'panel/login', :layout=>:layout_login
end

get '/login/suspended' do
  haml :'panel/login_suspended', :layout=>:layout_login
end

post '/login' do
  if session[:user] = Student.authenticate(params["email"], params["password"])
    pp "sdsdsdsds"
    pp Student.authenticate(params["email"], params["password"])
    redirect '/panel'
  else
    redirect '/login/retry'
  end
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end