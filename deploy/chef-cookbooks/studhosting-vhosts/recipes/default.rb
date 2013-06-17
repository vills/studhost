#
# Cookbook Name:: studhosting-vhosts
# Recipe:: default
#
# Copyright 2013, Vil Surkin
#
# All rights reserved - Do Not Redistribute
#

require 'json'

include_recipe "apache2"

apt_package "curl" do
  action :install
end


sites = `curl -s http://localhost/system/sites`
JSON.parse(`curl -s http://localhost:3000/system/sites`).each do |site|
  if File.directory?(site['docroot'])
    template "/etc/apache2/sites-enabled/studhosting-#{site['username']}_#{site['subdomain']}.conf" do
      source "vhost.conf.erb"
      mode 0444
      owner "root"
      group "root"
      variables({
        :server_name    => site['fqdn'],
        :server_aliases => ["www.#{site['fqdn']}"],
        :docroot        => site['docroot'],
        :logdir         => "#{site['open_basedir']}/logs",
        :logname        => site['subdomain'],
        :username       => site['username'],
        :open_basedir   => site['open_basedir']
        })
      action :create
      notifies :reload, "service[apache2]", :delayed
    end
  end
end
