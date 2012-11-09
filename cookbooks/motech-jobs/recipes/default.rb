#
# Cookbook Name:: motech-jobs
# Recipe:: default
#
# Copyright 2012, Grameen Foundation
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jenkins"

directory "/var/lib/jenkins/jobs" do
    owner "#{node[:jenkins][:server][:user]}"
    group "#{node[:jenkins][:server][:group]}"
    action :create
end

@node[:motech_jobs][:jobs_enabled].each do |job_name|
    directory "/var/lib/jenkins/jobs/#{job_name}" do
       owner "#{node[:jenkins][:server][:user]}"
       group "#{node[:jenkins][:server][:group]}"
       action :create
    end

    template "/var/lib/jenkins/jobs/#{job_name}/config.xml" do
        source "#{job_name}.xml.erb"
        owner "#{node[:jenkins][:server][:user]}"
        group "#{node[:jenkins][:server][:group]}"
    end
end

directory "/var/lib/jenkins/jobs/#{default[:motech_jobs][:release][:name]}" do
	owner "#{node[:jenkins][:server][:user]}"
    	group "#{node[:jenkins][:server][:group]}"
    	action :create
end

template "/var/lib/jenkins/jobs/#{default[:motech_jobs][:release][:name]}/config.xml" do
	owner "#{node[:jenkins][:server][:user]}"
        group "#{node[:jenkins][:server][:group]}"
	source "release.xml.erb"
end
