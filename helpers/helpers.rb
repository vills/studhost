#!/usr/bin/env ruby
#coding: UTF-8

module Helpers
  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    return str
  end
end

helpers do
  def authorized?
    session[:user]
  end

  def authorize!
    if authorized?
      redirect '/login/suspended' unless session[:user][:approved]
    else
      redirect '/login' unless authorized?
    end
  end

  def logout!
    session[:user] = nil  
    redirect '/'
  end

  def admin?
    if session[:user].nil?
      false
    else
      return session[:user][:is_admin] ? true : false
    end
  end

  def protected!
    halt [401, "Для доступа сюда необходима авторизация"] unless admin?
  end
end