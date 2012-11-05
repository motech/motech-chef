name "gerrit"
description "Gerrit server for the MOTECH Platform"

run_list "role[apache-server]",
        "recipe[mysql::ruby]",
        "recipe[mysql::server]",
        "recipe[gerrit]"

override_attributes(
  :gerrit => {
    :hostname => "review.motechproject.org",
    :canonicalWebUrl => "http://review.motechproject.org/"
  }
)

