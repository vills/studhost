#!/usr/bin/env ruby
#coding: UTF-8

class Site
  include DataMapper::Resource

  property :id,         Serial
  property :domain,     String, :required=>true, :key=>true,
                                :messages => {
                                  :presence  => "Нужно указать домен."
                                }

  property :password,   String, :required=>true, :required=>true, :length=>10

  def docroot
    "#{APP_CONFIG['sitespath']}/#{self.student.username}/#{self.domain}"
  end

  def open_basedir
    "#{APP_CONFIG['sitespath']}/#{self.student.username}"
  end

  def fqdn
    "#{self.domain}.#{self.student.username}.#{APP_CONFIG['domain']}"
  end

  belongs_to :student
end
