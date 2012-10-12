#
# Cookbook Name:: motech-jenkins
# Recipe:: default
#
# Copyright 2012, motechproject.org
#
# All rights reserved - Do Not Redistribute
#

version = node['activemq']['version']
mirror = node['activemq']['mirror']
activemq_home = "#{node['activemq']['home']}/apache-activemq-#{node['activemq']['version']}"

template "#{node[:jenkins][:server][:home]}/hudson.plugins.git.GitSCM.xml" do
	source "hudson.plugins.git.GitSCM.xml.erb"
	owner "#{node[:jenkins][:server][:user]}"
	group "#{node[:jenkins][:server][:group]}"
end

template "#{node[:jenkins][:server][:home]}/hudson.tasks.Maven.xml" do
        source "hudson.tasks.Maven.xml.erb"
        owner "#{node[:jenkins][:server][:user]}"
        group "#{node[:jenkins][:server][:group]}"
end

template "#{activemq_home}/conf/activemq.xml" do
        source "activemq.xml.erb"
        mode 0644
end

