chef_gem "inifile"

require 'inifile'

include_recipe 'couchdb'

tmp_dir = node["couchdb_lucene"]["tmp_dir"]
install_dir = node["couchdb_lucene"]["install_dir"]
deb_file = node["couchdb_lucene"]["deb_file"]
couchdb_local_ini_path = node["couchdb_lucene"]["couchdb_local_ini_path"]    

# include_recipe "couchdb-lucene::build-from-source"

service "couchdb-lucene" do
end

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

ruby_block "couchdb integration" do
	block do
		ini = IniFile.load couchdb_local_ini_path
		ini['couchdb']['os_process_timeout'] = "60000"
		ini['external']['fti'] = "/usr/bin/python #{install_dir}/tools/couchdb-external-hook.py"
		ini['httpd_global_handlers']['_fti'] = "{couch_httpd_external, handle_external_req, <<\"fti\">>}"
    ini['httpd_db_handlers']['_fti'] = "{couch_httpd_external, handle_external_req, <<\"fti\">>}"
		ini.save

		notifies :restart, resources(:service => "couchdb")
	end	
end

template "couchdb-lucene" do
  path "/etc/init.d/couchdb-lucene"
  source "couchdb-lucene.erb"
  mode "0755"
  notifies :restart, resources(:service => "couchdb-lucene")
end
