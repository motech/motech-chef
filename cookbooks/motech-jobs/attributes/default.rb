default[:motech_jobs][:jobs_enabled] = ["FullBuild", "UnitTestsBuild", "SonarBuild"]

default[:motech_jobs][:fullBuild][:name] = "FullBuild"
default[:motech_jobs][:fullBuild][:repository_url] = "https://code.google.com/p/motech/"
default[:motech_jobs][:fullBuild][:description] = "A full build of the master branch with integration tests."
default[:motech_jobs][:fullBuild][:schedule] = "@hourly"

default[:motech_jobs][:unitTestBuild][:name] = "OnlyUnitTestsBuild"
default[:motech_jobs][:unitTestBuild][:repository_url] = "https://code.google.com/p/motech/"
default[:motech_jobs][:unitTestBuild][:schedule] = "* * * * *"
default[:motech_jobs][:unitTestBuild][:description] = "A simple master branch build. Only unit tests."

default[:motech_jobs][:sonarBuild][:name] = "SonarBuild"
default[:motech_jobs][:sonarBuild][:repository_url] = "https://code.google.com/p/motech/"
default[:motech_jobs][:sonarBuild][:schedule] = "@midnight"
