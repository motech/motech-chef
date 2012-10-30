#
# Cookbook Name:: gerrit
# Recipe:: default
#
# Copyright 2012, Steffen Gebert / TYPO3 Association
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

####################################
# User setup
####################################

group node['gerrit']['group']

user node['gerrit']['user'] do
  gid node['gerrit']['group']
  home node['gerrit']['home']
  comment "Gerrit system user"
  shell "/bin/bash"
  system true
end


####################################
# Directories & Files
####################################

dirs = [
  node['gerrit']['home'],
  node['gerrit']['home'] + "/war",
  node['gerrit']['install_dir'],
  node['gerrit']['install_dir'] + "/etc",
  node['gerrit']['install_dir'] + "/lib", 
  node['gerrit']['install_dir'] + "/static"
]

dirs.each do |dir|
  directory dir do
    owner node['gerrit']['user']
    group node['gerrit']['group']
    recursive true
  end
end


%w{
  gerrit.config
  replication.config
}.each do |file|
  template "#{node['gerrit']['install_dir']}/etc/#{file}" do
    source "gerrit/#{file}"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
    notifies :restart, "service[gerrit]"
  end
end

template "#{node['gerrit']['install_dir']}/etc/secure.config" do
  source "gerrit/secure.config"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0600
  notifies :restart, "service[gerrit]"
end

template "/etc/default/gerritcodereview" do
  source "system/default.gerritcodereview.erb"
  mode 0644
  notifies :restart, "service[gerrit]"
end

node['gerrit']['theme']['compile_files'].each do |file|
  cookbook_file "#{node['gerrit']['install_dir']}/etc/#{file}" do
    source "gerrit/#{file}"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
    notifies :restart, "service[gerrit]"
  end
end

node['gerrit']['theme']['static_files'].each do |file|
  cookbook_file node['gerrit']['install_dir'] + "/static/" + file do
    source "gerrit/static/" + file
    owner node['gerrit']['user']
    group node['gerrit']['group']
  end
end

####################################
# MySQL
####################################

if node['gerrit']['database']['type'] == "MYSQL"
  require_recipe "gerrit::mysql"
end



####################################
# Proxy
####################################

if node['gerrit']['proxy']
  require_recipe "gerrit::proxy"
end


####################################
# Java
####################################


if platform?("debian") && !File.directory?(node['java']['java_home'])
  Chef::Log.warn "java_home doesn't exist. Adjusting it"
   
  if node['lsb']['codename'] == "wheezy"
    Chef::Log.info "Debian Wheezy, going for Java 7"
    node['java']['jdk_version'] = "7"
    node['java']['java_home'] = "/usr/lib/jvm/java-7-openjdk-amd64"
  else
    Chef::Log.info "Going for Java 6"
    node['java']['java_home'] = "/usr/lib/jvm/java-6-openjdk"
  end
end



####################################
# Deploy
####################################

require_recipe "java"
require_recipe "git"

#directory "#{node['gerrit']['home']}/war" do
#  owner node['gerrit']['user']
#  group node['gerrit']['group']
#end

if node['gerrit']['flavor'] == "war"
  filename = "#{node['gerrit']['home']}/war/gerrit-#{node['gerrit']['version']}.war"

  remote_file filename do
    owner node['gerrit']['user']
    source node['gerrit']['war']['download_url']
    # checksum node['gerrit']['war']['checksum'][node['gerrit']['version']]
    notifies :run, "bash[gerrit-init]", :immediately
    action :create_if_missing
  end
else
  require_recipe "gerrit::source"
  
  filename = "#{node['gerrit']['home']}/war/gerrit-#{node['gerrit']['version']}-#{node['gerrit']['source']['reference']}.war"

  bash "copy war" do
    Chef::Log.info "Created " + filename
    user node['gerrit']['user']
    code "cp #{node['gerrit']['home']}/src/git/gerrit-war/target/gerrit-*.war #{filename}"
    notifies :run, "bash[gerrit-init]", :immediately
    creates filename
  end
end

bash "gerrit-init" do
  user node['gerrit']['user']
  group node['gerrit']['group']
  cwd "#{node['gerrit']['home']}/war"
  code "java -jar #{filename} init --batch --no-auto-start -d #{node['gerrit']['install_dir']}"
  action :nothing
  notifies :restart, "service[gerrit]"
end

link "/etc/init.d/gerrit" do
  to "#{node['gerrit']['install_dir']}/bin/gerrit.sh"
end

link "/etc/rc3.d/S90gerrit" do
  to "../init.d/gerrit"
end

service "gerrit" do
  supports :status => false, :restart => true, :reload => true
  action [ :enable, :start ]
end



####################################
# Cron-Job
####################################

directory "#{node['gerrit']['home']}/scripts" do
  owner node['gerrit']['user']
end

template "#{node['gerrit']['home']}/scripts/repack-repositories.sh" do
  source "scripts/repack-repositories.sh"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0744
end

cron "repack-repositories" do
  hour "2"
  minute "0"
  weekday "0"
  command "#{node['gerrit']['home']}/scripts/repack-repositories.sh"
  user node['gerrit']['user']
end

