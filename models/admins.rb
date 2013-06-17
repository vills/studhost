#!/usr/bin/env ruby
#coding: UTF-8

class Admin
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required=>true
  property :login,      String, :required=>true
  property :password,   String, :length=>32, :required=>true
end
