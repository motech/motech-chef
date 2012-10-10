name "apache-server"
description "An apache2 server frontend"

run_list "recipe[apache2]",
         "recipe[apache2::mod_proxy_balancer]",
         "recipe[apache2::mod_proxy_ajp]",
         "recipe[apache2::mod_proxy_http]"

