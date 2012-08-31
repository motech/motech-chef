#
# Cookbook Name:: motech-server
# Recipe:: default
#
# Copyright 2012, motechproject.org
#
# All rights reserved - Do Not Redistribute
#

## Set up ajp(apache-tomcat) so that tomcat can "run" on port 80

template "#{node['apache']['dir']}/mods-available/proxy.conf" do
	source "proxy.conf.erb"
	mode "0644"
	owner "root"
end

template "#{node['apache']['dir']}/conf.d/ajp.conf" do
	source "ajp.conf.erb"
	mode "0644"
	owner "root"
end

## Dirs for motech
directory "#{node['motech_server']['dir']}" do
	owner "#{node['tomcat']['user']}"
	group "#{node['tomcat']['group']}"
	mode "0755"
	action :create
end

directory "#{node['motech_server']['conf_dir']}" do
        owner "#{node['tomcat']['user']}"
        group "#{node['tomcat']['group']}"
        mode "0755"
        action :create
end

directory "#{node['tomcat']['work_dir']}/felix-cache" do
	owner "#{node['tomcat']['user']}"
        group "#{node['tomcat']['group']}"
        mode "0755"
        action :create
end

template "#{node['motech_server']['conf_dir']}/motech-settings.conf" do
	source "motech-settings.conf.erb"
        mode "0644"
        owner "#{node['tomcat']['user']}"
        group "#{node['tomcat']['group']}"	
end

link "#{node['tomcat']['home']}/.motech" do
	to "#{node['motech_server']['dir']}"
end
