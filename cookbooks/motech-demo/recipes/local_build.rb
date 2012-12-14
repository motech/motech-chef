#
# Cookbook Name:: motech-demo
# Recipe:: local_build
#
# Copyright 2012, Grameen Foundation
#
# All rights reserved - Do Not Redistribute
#

user "#{node[:tomcat][:user]}" do
  shell "/bin/sh"
  action :modify
end

directory "#{node['motech_demo']['build_dir']}" do
  owner "#{node[:tomcat][:user]}"
  mode "0755"
  action :create
end

template "/etc/sudoers.d/tomcatrestart" do
    source "rights.erb"
    owner "root"
    group "root"
    mode 0440
end

template "#{node[:motech_demo][:build_dir]}/deploy.sh" do
    source "deploy.sh.erb"
    owner "#{node[:tomcat][:user]}"
    group "#{node[:tomcat][:user]}"
    mode 0755
end