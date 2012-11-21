## Sets up graphite at the same vhost with motech ##

template "#{node['apache']['dir']}/sites-available/motech.conf" do
	source "motech.conf.erb"
	owner "root"
	mode "0644"
end

script "add_graphite_hostname" do
	user "root"
	interpreter "bash"
	code <<-EOH
		if ! grep -q " #{node[:graphite][:url]}$" "/etc/hosts"; then
			echo "127.0.0.1 #{node['graphite']['url']}" >> /etc/hosts
		fi
		echo -e "\ngraphite.url=#{node[:motech_demo][:hostname]}/graphite/" >> #{node['motech_server']['conf_dir']}/motech-settings.conf
	EOH
end
