chef_gem "inifile"

require 'inifile'

include_recipe 'couchdb'

tmp_dir = node["couchdb_lucene"]["tmp_dir"]
install_dir = node["couchdb_lucene"]["install_dir"]
deb_file = node["couchdb_lucene"]["deb_file"]
couchdb_local_ini_path = node["couchdb_lucene"]["couchdb_local_ini_path"]    

# include_recipe "couchdb-lucene::build-from-source"

# fails 
# service "couchdb-lucene" do
#   action [:enable, :start]
# end

bash 'install deb' do
	
	cwd tmp_dir

	code <<-EOH
		rm -rf #{tmp_dir}/*.deb
		wget #{deb_file}
		dpkg -i #{tmp_dir}/couchdb-lucene*.deb

		service couchdb-lucene start
	EOH

	# notifies :start, resources(:service => "couchdb-lucene"), :immediately
end

log "couchdb integration" do
	ini = IniFile.load couchdb_local_ini_path
	ini['couchdb']['os_process_timeout'] = "60000"
	ini['external']['fti'] = "#{install_dir}/tools/couchdb-external-hook.py"
	ini['httpd_global_handlers']['_fti'] = "{couch_httpd_proxy, handle_proxy_req, <<\"fti\">>}"
	ini.save

	notifies :restart, resources(:service => "couchdb")
end
