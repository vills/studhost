#!/usr/bin/env ruby
#coding: UTF-8

class Admin
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required=>true
  property :login,      String, :required=>true
  property :password,   String, :length=>32, :required=>true
end


# << USERS >> #
class User
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required=>true, :index=>true
  property :email,      String, :required=>true, :index=>true
  property :password,   String, :length=>32, :required=>true

  belongs_to :speciality
end

class Speciality
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :required=>true, :index=>true

  has n, :users
  belongs_to :faculty
end

class Faculty
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :required=>true, :index=>true

  has n, :specialities
end
# >> USERS << #