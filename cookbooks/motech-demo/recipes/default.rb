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

template "#{node['motech_demo']['build_dir']}/openmrs-1.8.sql" do
	source "openmrs-1.8.sql.erb"
	owner "root"
	mode "0644"
end

script "bootstrap" do
	user "root"
	interpreter "bash"
	code <<-EOH
	MYSQL_PASS=#{node['mysql']['server_root_password']}
	BUILD_DIR=#{node['motech_demo']['build_dir']}
	OPENMRS_DB=#{node['motech_demo']['openmrs']['db']['name']}
	OPENMRS_USER=#{node['motech_demo']['openmrs']['db']['user']}
	OPENMRS_PASS=#{node['motech_demo']['openmrs']['db']['password']}
	
	mysql -u root -p$MYSQL_PASS -e "DROP DATABASE IF EXISTS $OPENMRS_DB; CREATE DATABASE $OPENMRS_DB DEFAULT CHARSET utf8;"
        mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON $OPENMRS_DB.* TO '$OPENMRS_USER'@'localhost' IDENTIFIED BY '$OPENMRS_PASS';"
        mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON $OPENMRS_DB.* TO '$OPENMRS_USER'@'%' IDENTIFIED BY '$OPENMRS_PASS';"
        mysql -u root -p$MYSQL_PASS -e "FLUSH PRIVILEGES;"	

	mysql -u $OPENMRS_USER -p$OPENMRS_PASS $OPENMRS_DB < $BUILD_DIR/openmrs-1.8.sql
	EOH
end

package "unzip" do
	action :install
end

script "build" do
	user "root"
	interpreter "bash"
	code <<-EOH
		#{node['motech_demo']['build_dir']}/build.sh
	EOH
	only_if "test -L #{node['java']['java_home']} || test -d #{node['java']['java_home']}"
	#subscribes :run, resources("ruby_block[update-java-alternatives]"), :immediately
end

if (node['motech_demo']['rebuild'] == true) then
	cron "rebuild" do
		hour "5"
		minute "0"
		command "#{node['motech_demo']['build_dir']}/build.sh"
	end
end