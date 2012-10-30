***Note***: This cookbook is still a work in progress!

Description
===========

Installs the [Gerrit](http://code.google.com/p/gerrit/) review system. Optional support for MySQL database and Apache2 as proxy server is included.

Requirements
============

## Platform:

* Debian 6.0 and 7.0
* other platforms untested

## Cookbooks:

* build-essential
* mysql
* database
* java
* git
* maven
* apache2

Attributes
==========

These attributes are set by the cookbook by default.

Deployment
----------

* `node['gerrit']['flavor']` - Installation type, either `war` or `source`. `war` downloads the `.war` file from `download_url`. `source` checks out the git repository `repository` and builds it using Maven. Please note that the `source` flavor is absolutely *not* recommended for production use. Building Gerrit will cause severe load on your server!
* `node['gerrit']['version']` - Gerrit version to deploy.
* `node['gerrit']['download_url']` - URL to download the `.war` file from. Defaults to `http://gerrit.googlecode.com/files/gerrit-#{node['gerrit']['version']}.war`
* `node['gerrit']['repository']` - Git repository containing the Gerrit source code. Defaults to `https://gerrit.googlesource.com/gerrit`.
* `node['gerrit']['reference']` - Git revision or branch name to checkout.

User and path setup
-------------------

* `node['gerrit']['user']` - User, under which Gerrit runs ([container.user](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#container.user)). Defaults to `gerrit`.
* `node['gerrit']['group']` -  Group name of the `gerrit` user. Defaults to `gerrit`.
* `node['gerrit']['home']` - Home directory of the `gerrit` user. Defaults to `/var/gerrit`.
* `node['gerrit']['install_dir']` - Directory, where Gerrit is installed into. Defaults to `node['gerrit']['home']/review`.

HTTP and friends
----------------

* `node['gerrit']['hostname']` - The default hostname for Gerrit to be accessed through. Defaults to `fqdn`.
* `node['gerrit']['canonicalWebUrl']` - The default URL for Gerrit to be accessed through. Typically this would be set to "http://review.example.com/" or "http://example.com/gerrit/" so Gerrit can output links that point back to itself. ([gerrit.canonicalWebUrl](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#gerrit.canonicalWebUrl)). Defaults to `http://#{node['fqdn']}/`.
connections on ([sshd.listenAddress](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#sshd.listenAddress)).
* `node['gerrit']['proxy']` - Enable Apache2 reverse proxy in front of Gerrit. Defaults to `true`, which makes Gerrit available on port 80.
* `node['gerrit']['ssl']` - Enable SSL for the reverse proxy. Uses snakeoil certificates. Defaults to `false`.

SSHD
----

* `node['gerrit']['port']` - Specifies the local addresses the internal SSHD should listen for 
 
Database configuration
----------------------

* `node['gerrit']['database']['type']` - Type of database server to connect to ([database.type](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#database.type)). Defaults to `MYSQL`.
* `node['gerrit']['database']['hostname']` - Hostname of the database server ([database.hostname](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#database.hostname)). Defaults to `localhost`.
* `node['gerrit']['database']['name']` - For `POSTGRESQL` or `MYSQL`, the name of the database on the server. For `H2`, this is the path to the database, and if not absolute is relative to `$site_path ` ([database.database](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#database.hostname)). Defaults to `gerrit`.

* `node['gerrit']['database']['username']` - Username to connect to the database server as ([database.hostname](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#database.username)). Defaults to `gerrit`.
* `node['gerrit']['database']['password']` - Password to authenticate to the database server with ([database.hostname](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-gerrit.html#database.password)). Defaults to `gerrit`.

Theme
-----

* `node['gerrit']['theme']['compile_files]` - Hash of files deployed to `etc/`. Possible file names are `GerritSite(Header|Footer).html` and `GerritSite.css`. Changing these files results in a Gerrit restart. See [Gerrit docs](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-headerfooter.html#_html_header_footer).
* `node['gerrit']['static_files']` - Hash of files deployed to `static/`. Files, which can be used in a custom theme and are available through `#{node['gerrit']['canonicalWebUrl']}/static/`. See [Gerrit docs](http://gerrit-documentation.googlecode.com/svn/Documentation/2.4.2/config-headerfooter.html#_static_images).

Recipes
=======

default
-------
Sets up Gerrit. Includes other recipes, if needed (no need to add them to your run list on your own).

mysql
-----
Configures the MySQL server, if `node['gerrit']['database']['type'] == "MYSQL"`.

proxy
-----
Installs Apache2 as reverse proxy in front of Gerrit, if enabled through `node['gerrit']['proxy']`. This also binds Gerrit's HTTPD to `localhost` on port 8080.
HTTPS support is available, if `node['gerrit']['proxy']` is set.

source
------
Checks out the Git repository configured in `node['gerrit']['repository']` and runs the `tools/release.sh` script, which builds Gerrit. **Note**: This is *not* intended for production use, but might be useful while developing Gerrit!


Usage
=====

Create a role for the OpenVPN server. See above for attributes that can be entered here.

    % cat roles/gerrit.rb
    name 'gerrit'
    description 'A Gerrit server'
    run_list(
      'recipe[gerrit]',
      'recipe[git-daemon]'
    )
    override_attributes(
      'gerrit' => {
        'version' => 'full-2.5.0',
      }
    )

Using the `git-daemon` cookbook is suggested, if you want to make your repositories available also through the Git protocol. Gerrit itself only supports SSH and HTTP(S).

Deployment Process
==================

war
---
When `flavor` `war` is specified, the `.war` file is downloaded into `node['gerrit']['install_dir']/war`.. This triggers to run `java -jar gerrit.war init -d /path/to/gerrit`, which initializes the Gerrit installation.

source
------
When the Git repository changes, a new build through Gerrit's `tools/release.sh` is triggered and created through Maven. Afterwards, the resulting `.war` file is processed as described above for `war` deplyoment.

Upgrading Gerrit
-----------------
A new Gerrit version is installed, as soon as a new `.war` file is available through one of the methods described above.
The `init` command is called automatically and if schema migrations have to be made, they are executed automatically.

License and Author
==================

Author:: Steffen Gebert (<steffen.gebert@typo3.org>)

Copyright:: 2012, Steffen Gebert / TYPO3 Association

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.