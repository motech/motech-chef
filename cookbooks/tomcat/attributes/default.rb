#
# Cookbook Name:: jetty
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default["tomcat"]["base_version"] = "7"
default["tomcat"]["port"] = 8080
default["tomcat"]["ssl_port"] = 8443
default["tomcat"]["ajp_port"] = 8009
default["tomcat"]["java_options"] = "-Xmx128M -Djava.awt.headless=true"
default["tomcat"]["use_security_manager"] = false
default["tomcat"]["redis"] = false

case platform
when "centos","redhat","fedora"
  set["tomcat"]["user"] = "tomcat"
  set["tomcat"]["group"] = "tomcat"
  set["tomcat"]["home"] = "/usr/share/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["base"] = "/usr/share/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["config_dir"] = "/etc/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["log_dir"] = "/var/log/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["tmp_dir"] = "/var/cache/tomcat#{tomcat["base_version"]}/temp"
  set["tomcat"]["work_dir"] = "/var/cache/tomcat#{tomcat["base_version"]}/work"
  set["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  set["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{tomcat["base_version"]}/webapps"
when "debian","ubuntu"
  set["tomcat"]["user"] = "tomcat#{tomcat["base_version"]}"
  set["tomcat"]["group"] = "tomcat#{tomcat["base_version"]}"
  set["tomcat"]["home"] = "/usr/share/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["base"] = "/var/lib/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["config_dir"] = "/etc/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["log_dir"] = "/var/log/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["tmp_dir"] = "/tmp/tomcat#{tomcat["base_version"]}-tmp"
  set["tomcat"]["work_dir"] = "/var/cache/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  set["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{tomcat["base_version"]}/webapps"
else
  set["tomcat"]["user"] = "tomcat#{tomcat["base_version"]}"
  set["tomcat"]["group"] = "tomcat#{tomcat["base_version"]}"
  set["tomcat"]["home"] = "/usr/share/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["base"] = "/var/lib/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["config_dir"] = "/etc/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["log_dir"] = "/var/log/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["tmp_dir"] = "/tmp/tomcat#{tomcat["base_version"]}-tmp"
  set["tomcat"]["work_dir"] = "/var/cache/tomcat#{tomcat["base_version"]}"
  set["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  set["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{tomcat["base_version"]}/webapps"
end
