name "graphite-server"
description "A graphite/statsd server"
run_list "recipe[graphite]", "recipe[statsd]"
