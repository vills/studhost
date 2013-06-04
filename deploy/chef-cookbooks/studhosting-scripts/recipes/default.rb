#
# Cookbook Name:: studhosting-scripts
# Recipe:: default
#
# Copyright 2013, Vil Surkin
#
# All rights reserved - Do Not Redistribute
#

cmds = Array.new

script_dir = '/usr/local/bin'
[
  "user-create.sh",
  "site-create.sh",
  "filemanager-create.sh"
].each do |file|
  cookbook_file "#{script_dir}/studhosting-#{file}" do
    source file
    owner "root"
    group "root"
    mode  0700
  end
  cmds << "#{script_dir}/studhosting-#{file}"
end

sudo "studhosting" do
  user "www-data"
  nopasswd true
  commands cmds
end
