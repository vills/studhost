#!/usr/bin/env ruby
#coding: UTF-8

class Student
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required=>true, :index=>true, :length => 255
  property :email,      String, :required=>true, :index=>true
  property :password,   String, :length=>32, :required=>true

  belongs_to :speciality
end

class Speciality
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :required=>true, :index=>true, :length => 255

  has n, :students, :constraint => :destroy
  belongs_to :faculty
end

class Faculty
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :required=>true, :index=>true, :length => 255

  has n, :specialities, :constraint => :destroy
end
