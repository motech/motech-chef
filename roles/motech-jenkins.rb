name "motech-jenkins"
description "Jenkins CI server for the MOTECH Platform"

run_list "role[apache-server]",
        "recipe[apt]",
        "recipe[java]",
        "recipe[maven::maven3]",
        "recipe[git]",
	"recipe[couchdb]",
	"recipe[activemq]",
        "recipe[jenkins]",
        "recipe[motech-jenkins]"

override_attributes(
  :jenkins => {
    :http_proxy => { 
      :variant => "apache2",
      :host_name => "fufu.motechproject.org",
      :basic_auth => "disabled"
    },
    :server => { 
      :plugins => ["gerrit-trigger", "git"],
      :host => "localhost",
      :port => 8060
    }
  },
  :java => {
    :install_flavor => "oracle",
    :jdk_version => 7,
    :oracle => {
      :accept_oracle_download_terms => true
    }
  },
  :maven => {
    :version => 3,
    "3" => {
        :url => "http://www.apache.org/dist/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz"
    }
  }
)
