default[:motech_jenkins][:git][:name] = "jenkins"
default[:motech_jenkins][:git][:email] = "jenkins@fufu.motechproject.org"
default[:motech_jenkins][:mysql][:user] = "jenkins"
default[:motech_jenkins][:mysql][:password] = "j3nk1ns"

default[:motech_jenkins][:sonar][:name] = "MOTECH Sonar"
default[:motech_jenkins][:sonar][:disabled] = false
default[:motech_jenkins][:sonar][:database][:url] = "jdbc:mysql://localhost:3306/sonar?useUnicode=true&amp;characterEncoding=utf8"
default[:motech_jenkins][:sonar][:database][:driver] = "com.mysql.jdbc.Driver"
default[:motech_jenkins][:sonar][:database][:login] = "sonar"
default[:motech_jenkins][:sonar][:database][:password] = "c29uYXI="
default[:motech_jenkins][:sonar][:skip][:scm] = false
default[:motech_jenkins][:sonar][:skip][:upstream] = false
