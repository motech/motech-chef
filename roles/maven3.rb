name "maven3"
description "Installs maven 3"

run_list "recipe[maven::maven3]"

override_attributes(
  :maven => {
    :version => 3,
    "3" => {
      :url => "http://www.apache.org/dist/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz"
    }
  }
)