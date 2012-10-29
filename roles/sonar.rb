name "sonar"
description "Sonar server for the MOTECH Platform"

run_list "role[apache-server]",
        "recipe[mysql::server]",
        "recipe[sonar]",
        "recipe[sonar::database_mysql]",
        "recipe[sonar::proxy_apache]"

override_attributes(
  :sonar => {
    :version => "3.3",
    :checksum => "3e559103f9e2f8505330ad1b33c2382b",
    :web_domain => "sonar.motechproject.org",
    :jdbc_url => "jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8",
    :jdbc_driverClassName => "com.mysql.jdbc.Driver",
    :jdbc_validationQuery => "select 1"
  }
)
