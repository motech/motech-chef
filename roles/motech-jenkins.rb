name "motech-jenkins"
description "Jenkins CI server for the MOTECH Platform"

run_list "role[apache-server]",
        "recipe[apt]",
        "recipe[java]",
        "recipe[maven::maven3]",
        "recipe[ant]",
        "recipe[doxygen]",
        "recipe[git]",
        "recipe[couchdb]",
        "recipe[activemq]",
        "recipe[jenkins]",
        "recipe[motech-jenkins]",
        "recipe[motech-jenkins::bootstrapdb]",
        "recipe[motech-jobs]"

override_attributes(
  :jenkins => {
    :http_proxy => { 
      :variant => "apache2",
      :host_name => "ci.motechproject.org",
      :host_aliases => ["fufu.motechproject.org"],
      :basic_auth => "disabled"
    },
    :server => { 
      :plugins => ["gerrit-trigger", "git", "greenballs", "locks-and-latches", "sonar"],
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
  },
  :authorization => {
      :sudo => {
        :include_sudoers_d => true
      }
  }
)
