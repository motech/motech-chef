default[:motech_secrets][:secret] = "/etc/chef/encrypted_data_bag_secret"
default[:motech_secrets][:bag] = "passwords"
default[:motech_secrets][:item] = node.name
