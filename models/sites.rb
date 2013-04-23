#!/usr/bin/env ruby
#coding: UTF-8

class Site
  include DataMapper::Resource

  property :id,         Serial
  property :domain,     String, :required=>true, :key=>true, :unique=>true,
                                :messages => {
                                  :presence  => "Нужно указать домен.",
                                  :is_unique => "Такой домен уже существует. Выберите другой.",
                                }

  property :password,   String, :required=>true, :required=>true, :length=>10

  belongs_to :student
end
