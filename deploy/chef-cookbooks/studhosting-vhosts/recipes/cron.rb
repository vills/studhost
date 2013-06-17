#
# Cookbook Name:: studhosting-vhosts
# Recipe:: cron
#
# Copyright 2013, Vil Surkin
#
# All rights reserved - Do Not Redistribute
#

hname = `hostname -f`

cron "studhosting-vhosts" do
  action :create
  command "/opt/chef/bin/chef-solo -c /var/www/.panel/deploy/chef-solo.rb -j /var/www/.panel/deploy/chef-solo-cron.json -N #{hname}"
  minute "*/10"
end
