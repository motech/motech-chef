#
# Cookbook Name:: swapfile
# Recipe:: default
#
# Copyright 2012, Grameen Foundation
#
# All rights reserved - Do Not Redistribute
#

execute "createswap" do
  command "/usr/sbin/create_swap.sh"
  creates "/swapfile"
  action :nothing
end

template "/usr/sbin/create_swap.sh" do
  source "create_swap.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :run, resources(:execute => "createswap")
end
