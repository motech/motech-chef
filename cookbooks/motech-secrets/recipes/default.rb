#
# Cookbook Name:: motech-secrets
# Recipe:: default
#
# Copyright 2012, Grameen Foundation
#
# All rights reserved - Do Not Redistribute
#

bag = "#{node[:motech_secrets][:bag]}"
item = "#{node[:motech_secrets][:item]}"

secret_file = File.open("#{node[:motech_secrets][:secret]}", "rb");
secret = secret_file.read

creds = Chef::EncryptedDataBagItem.load(bag, item, secret);

if creds
    mysql_pass = "#{creds["mysql_root_password"]}"
    if mysql_pass
        node[:mysql][:server_root_password] = mysql_pass
    end
end
