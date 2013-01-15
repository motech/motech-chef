name "jenkins-base"
description "Base jenkins role"

run_list "role[apache-server]",
        "role[oracle-jdk7]",
        "recipe[apt]",
        "recipe[maven::maven3]",
        "recipe[ant]",
        "recipe[doxygen]",
        "recipe[git]",
        "recipe[jenkins]",
        "recipe[couchdb-lucene]"        

override_attributes(
  :jenkins => {
    :http_proxy => { 
      :variant => "apache2",
      :host_name => "ci.motechproject.org",
      :basic_auth => "disabled"
    },
    :server => { 
      :plugins => ["gerrit-trigger", "git", "greenballs", "locks-and-latches", "sonar", "ci-game", "performance"],
      :host => "localhost",
      :port => 8060
    }
  },
  :maven => {
    :version => 3,
    "3" => {
        :url => "http://www.apache.org/dist/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz"
    }
  },
  :motech_jobs => {
    :jobs_enabled => ["UnitTestsBuild"]
  }
)