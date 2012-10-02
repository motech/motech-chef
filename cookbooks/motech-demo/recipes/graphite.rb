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
	EOH
end