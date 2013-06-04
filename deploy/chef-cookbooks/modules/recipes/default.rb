#
# Cookbook Name:: modules
# Recipe:: default
#
# Copyright 2013, Vil Surkin
#
# All rights reserved - Do Not Redistribute
#


node['modules'].each do |mod|

  bash "modprobe #{mod}" do
    code "modprobe #{mod}"
    not_if "lsmod |grep #{mod}"
  end
 
  bash "install #{mod} in /etc/modules" do
    code "echo '#{mod}' >> /etc/modules"
    not_if "grep '^#{mod}$' /etc/modules"
  end

end
