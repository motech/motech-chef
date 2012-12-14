name "motech-demo-jenkins"
description "Motech demo server built as a jenkins slave"
run_list     "role[motech-server]", "role[maven3]", "recipe[motech-demo::local_build]"

override_attributes(
  :authorization => {
      :sudo => {
        :include_sudoers_d => true
      }
  },
  :mysql => {
      :server_root_password => "password"
  }
)  

default_attributes(
  :motech_demo => {
    :hostname => "demo.motechproject.org"
  }
)


