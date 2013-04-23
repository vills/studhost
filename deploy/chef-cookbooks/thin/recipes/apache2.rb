#
# Cookbook Name:: thin
# Recipe:: apache2
#
# Copyright 2013, Vil Surkin
#

include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_balancer"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_rewrite"

ports = Array.new
node['thin']['servers'].to_i.times do |i|
  ports << 3000 + i
end


template "#{node['apache']['dir']}/sites-available/thin" do
  source "apache2/thin.erb"
  mode 0644
  user "root"
  group "root"
  variables( :ports => ports )
  notifies :reload, "service[apache2]"
end

apache_site "thin" do
  enable 
end
