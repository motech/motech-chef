#
# Cookbook Name:: motech-jenkins
# Recipe:: default
#
# Copyright 2012, motechproject.org
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jenkins"

activemq_home = "#{node['activemq']['home']}/apache-activemq-#{node['activemq']['version']}"

template "#{node[:jenkins][:server][:home]}/hudson.plugins.git.GitSCM.xml" do
	source "hudson.plugins.git.GitSCM.xml.erb"
	owner "#{node[:jenkins][:server][:user]}"
	group "#{node[:jenkins][:server][:group]}"
end

template "#{node[:jenkins][:server][:home]}/hudson.plugins.sonar.SonarPublisher.xml" do
        source "hudson.plugins.sonar.SonarPublisher.xml.erb"
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

template "/etc/sudoers.d/jenkins" do
    source "jenkins.rights.ebr"
    owner "root"
    group "root"
    mode 0440
end


