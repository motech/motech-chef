#
# Cookbook Name:: motech-jenkins
# Recipe:: bootstrapdb
#
# Copyright 2012, motechproject.org
#
# All rights reserved - Do Not Redistribute
#

script "permissions" do
    user "root"
    interpreter "bash"
    code <<-EOH

    MYSQL_PASS="#{node[:mysql][:server_root_password]}"
    JENKINS_USER="#{node[:motech_jenkins][:mysql][:user]}"
    JENKINS_PASS="#{node[:motech_jenkins][:mysql][:password]}"

    mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON openmrs.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
    mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON openmrs190.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
    mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON motech_openmrs_api.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
    mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON openmrs_api_test.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
    mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON motech.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"

    EOH
end