#
# Cookbook Name:: motech-jenkins
# Recipe:: deb-it
#
# Copyright 2012, Grameen Foundation
#
# All rights reserved - Do Not Redistribute
#
package "debootstrap" do
    action :install
end

directory "#{node[:motech_jenkins][:wheezy_dir]}" do
    owner "#{node[:jenkins][:server][:user]}"
    group "#{node[:jenkins][:server][:group]}"
    action :create
end

script "install-wheezy" do
    user "root"
    interpreter "bash"
    code <<-EOH
        W_DIR="#{node[:motech_jenkins][:wheezy_dir]}"
        CHROOT="chroot $W_DIR"

        debootstrap wheezy $W_DIR

        mount --bind /proc $W_DIR/proc
        mount --bind /dev $W_DIR/dev

        # install java because it takes too long to install/uninstall with every test
        $CHROOT apt-get install openjdk-7-jre --force-yes -y

        umount $W_DIR/dev
    EOH
end


