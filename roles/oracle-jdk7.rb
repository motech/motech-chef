name "oracle-jdk7"
description "Installs oracle java version 7"

run_list "recipe[java]"

override_attributes(
  :java => {
    :install_flavor => "oracle",
    :jdk_version => 7,
    :oracle => {
      :accept_oracle_download_terms => true
    }
  }
)