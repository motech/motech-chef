#
# Cookbook Name:: motech-jenkins
# Recipe:: bootstrapdb
#
# Copyright 2012, motechproject.org
#
# All rights reserved - Do Not Redistribute
#

bag = "passwords"
item = "#{node[:name]}"

creds = Chef::EncryptedDataBagItem.load(bag, item)
mysql_pass = creds ? creds["mysql_root_password"] : nil

if mysql_pass
    script "permissions" do
        user "root"
        interpreter "bash"
        code <<-EOH

        MYSQL_PASS="#{mysql_pass}"
        JENKINS_USER="#{node[:motech_jenkins][:mysql][:user]}"
        JENKINS_PASS="#{node[:motech_jenkins][:mysql][:password]}"

        echo $MYSQL_PASS

        mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON openmrs.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
        mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON openmrs190.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
        mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON motech_openmrs_api.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"
        mysql -u root -p$MYSQL_PASS -e "GRANT ALL ON openmrs_api_test.* TO '$JENKINS_USER'@'localhost' IDENTIFIED BY '$JENKINS_PASS' WITH GRANT OPTION"

        EOH
    end
end