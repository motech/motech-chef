name "prod"
description "Motech production environment"
default_attributes "apache2" => { "listen_ports" => [ "80", "443" ] }
