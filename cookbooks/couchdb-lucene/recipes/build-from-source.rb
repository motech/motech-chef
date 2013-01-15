include_recipe 'git'
include_recipe 'maven'

tmp_dir = node["couchdb_lucene"]["tmp_dir"]
install_dir = node["couchdb_lucene"]["install_dir"]
release_commit = node["couchdb_lucene"]["release_commit"]

bash 'build couchdb-lucene' do
	
	cwd tmp_dir

	code <<-EOH
		# git clone git://github.com/rnewson/couchdb-lucene.git
		# cd couchdb-lucene
		# git reset --hard #{release_commit}

		# mvn clean assembly:assembly  		

		# rm -rf #{install_dir}/*
		# mkdir -p #{install_dir}
		# unzip -o -d #{install_dir} #{tmp_dir}/couchdb-lucene/target/couchdb-lucene-*dist.zip
	EOH

end

