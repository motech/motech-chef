template "couchdb-lucene" do
  path "/etc/init.d/couchdb-lucene"
  source "couchdb-lucene.erb"
  mode "0755"
  notifies :restart, resources(:service => "couchdb-lucene")
end
