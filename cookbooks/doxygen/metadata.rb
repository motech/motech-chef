maintainer       "Grameen Foundation"
maintainer_email "motech-dev@googlegroups.com"
license          "All rights reserved"
description      "Installs/Configures doxygen"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w(yum apt).each { |cb| recommends cb }
