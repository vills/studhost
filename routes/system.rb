#!/usr/bin/env ruby
#coding: UTF-8

before '/system*' do
  halt [401, "Уйди, злостный хэйкер!"] unless request.ip == '127.0.0.1'
end

get '/system/sites' do
  content_type :json
  @sites = Array.new
  Site.all.each do |site| 
    @sites << {
      :fqdn=>"#{site.domain}.#{site.student.username}.#{APP_CONFIG['domain']}",
      :docroot=>site.docroot,
      :open_basedir=>site.open_basedir,
      :username=>site.student.username,
      :subdomain=>site.domain }
  end
  @sites.to_json
end
