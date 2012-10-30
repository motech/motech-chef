#
# Cookbook Name:: gerrit
# Recipe:: mysql
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

require_recipe "build-essential"
require_recipe "mysql"
require_recipe "mysql::server"
require_recipe "database"

# package "libmysql-java"

remote_file "#{node['gerrit']['install_dir']}/lib/mysql-connector-java-5.1.10.jar" do
  source "http://repo2.maven.org/maven2/mysql/mysql-connector-java/5.1.10/mysql-connector-java-5.1.10.jar"
  checksum "cf194019de3e54b3a9b9980462"
  owner node['gerrit']['user']
  group node['gerrit']['group']
end

mysql_connection_info = {
  :host =>  "localhost",
  :username => "root",
  :password => node['mysql']['server_root_password']
}


###### this all doesn't work well, because Mysql.new tries to connect to MySQL which isn't running, yet..

## we have to enforce installation of that package right now - before the chef_gem
#package "libmysqlclient-dev" do
#  action :install
#end.run_action(:install)

#begin
#  chef_gem "mysql" do
#    action :install
#  end
#  require "mysql"
#  m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
#  if m.list_dbs.include?(node['gerrit']['database']['name']) == false
 
mysql_database node['gerrit']['database']['name'] do
connection mysql_connection_info
  action :create
end

mysql_database "changing the charset of database" do
  connection mysql_connection_info
  database_name node['gerrit']['database']['name']
  action :query
  sql "ALTER DATABASE #{node['gerrit']['database']['name']} charset=latin1"
end

mysql_database_user node['gerrit']['database']['username'] do
  connection mysql_connection_info
  password node['gerrit']['database']['password']
  action :create
end

mysql_database_user node['gerrit']['database']['username'] do
  connection mysql_connection_info
  database_name node['gerrit']['database']['name']
  privileges [
    :all
  ]
  action :grant
end

mysql_database "flushing mysql privileges" do
  connection mysql_connection_info
  action :query
  sql "FLUSH PRIVILEGES"
end