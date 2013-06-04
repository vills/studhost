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

  def docroot
    "#{APP_CONFIG['sitespath']}/#{self.student.username}/#{self.domain}"
  end

  def open_basedir
    "#{APP_CONFIG['sitespath']}/#{self.student.username}"
  end

  belongs_to :student
end
