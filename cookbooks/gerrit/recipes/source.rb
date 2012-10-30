#
# Cookbook Name:: gerrit
# Recipe:: source
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

include_recipe "maven"

directory "#{node['gerrit']['home']}/src/git" do
  owner node['gerrit']['user']
  group node['gerrit']['group']
  recursive true
end

git "gerrit-repo" do
  destination "#{node['gerrit']['home']}/src/git" 
  repository node['gerrit']['source']['repository']
  reference node['gerrit']['source']['reference']
  user node['gerrit']['user']
  group node['gerrit']['group']
  notifies :run, "execute[clean-repo]", :immediately
  notifies :run, "execute[release-gerrit]", :immediately
end

execute "clean-repo" do
  cwd "#{node['gerrit']['home']}/src/git"
  user node['gerrit']['user']
  command "git ls-files --others --exclude-standard"
  action :nothing
end

execute "release-gerrit" do
  Chef::Log.info "Compiling Gerrit. This will take a long time!"
  cwd "#{node['gerrit']['home']}/src/git"
  user node['gerrit']['user']
  command "tools/release.sh"
  action :nothing
end