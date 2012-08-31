#
# Cookbook Name:: motech-demo
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "#{node['motech_demo']['build_dir']}" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

template "#{node['motech_demo']['build_dir']}/build.sh" do
	source "build.sh.erb"
	owner "root"
	mode "0755"
end

template "#{node['motech_demo']['build_dir']}/pom.xml" do
	source "pom.xml.erb"
	owner "root"
	mode "0644"
end

cron "rebuild" do
  hour "5"
  minute "0"
  command "#{node['motech_demo']['build_dir']}/build.sh"
end
