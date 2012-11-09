name "motech-jenkins"
description "Jenkins CI server for the MOTECH Platform"

run_list "role[jenkins-base]",
        "recipe[mysql::server]",
        "recipe[mysql::client]",
        "recipe[couchdb]",
        "recipe[activemq]",
        "recipe[motech-jenkins::bootstrapdb]",
        "recipe[motech-jenkins]"

override_attributes(
  :authorization => {
      :sudo => {
        :include_sudoers_d => true
      }
  },
  :motech_jobs => {
    :jobs_enabled => ["FullBuild", "UnitTestsBuild", "SonarBuild"]
  }
)
