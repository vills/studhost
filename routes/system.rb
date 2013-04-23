#!/usr/bin/env ruby
#coding: UTF-8

before '/system*' do
  halt [401, "Уйди, злостный хэйкер!"] unless request.ip == '127.0.0.1'
end

get '/system/sites' do
  content_type :json
  @sites = Array.new
  Site.all.each do |site|
    pp site
    student = site.student.username
    @sites << [ student, site.domain, site.password ]
  end
  @sites.to_json
end
