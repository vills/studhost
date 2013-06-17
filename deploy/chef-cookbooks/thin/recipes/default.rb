#
# Cookbook Name:: thin
# Recipe:: default
#
# Copyright 2013, Vil Surkin
#


package "g++" do
  action :install
end


gem_package "thin" do
  action :install
end


[ '/var/log/thin', '/var/run/thin' ].each do |d|
  directory d do
    user "www-data"
    group "www-data"
  end
end

template '/etc/init.d/thin' do
  source  'init.d.erb'
  mode    0755
  owner   'root'
  group   'root'
end

service "thin" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

directory '/etc/thin' do
  mode 0755
  owner "root"
  group "root"
end

template '/etc/thin/thin.conf' do
  source  'thin.conf.erb'
  mode    0644
  owner   'root'
  group   'root'
  notifies :restart, "service[thin]"
end


sudo "vagrant" do
  user "vagrant"
  nopasswd true
  only_if "/usr/bin/id vagrant"
end
