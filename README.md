# Capistrano::Inaminute

## Installation
Add this line to your application's Gemfile:

```
gem 'capistrano-inaminute', git: 'git@github.com:grezar/capistrano-inaminute.git'
```

And then execute:

```
bundle
```

## Usage
Capistrano 3.7+ is required.

```Capfile
require 'capistrano/setup'

require 'capistrano/inaminute/plugin'
install_plugin Capistrano::Inaminute::Plugin

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
```

NOTE: Don't do `require 'capistrano/deploy'`. This will load default Capistrano tasks but capistrano-inaminute doesn't work with them.

Edit config/deploy.rb as follow

```
set :application, "example"
set :repo_url, "git@github.com:grezar/capistrano-inaminute.git"
set :branch, ENV["BRANCH"] || "master"
set :deploy_to, "#{ENV["HOME"]}/#{fetch(:application)}"

set :inaminute_local_release_path, fetch(:deploy_to)
```

and also the stage file like config/deploy/example.rb

```
server 'build', roles: %w(build)
server 'app', roles: %w(web)
```

capistrano-inaminute execute every build step (e.g. `bundle install`, `rake assets:precompile`) on a server had the "build" role.
The role "web" is where the application is actually deployed.

### The very first deploy
The following task have to execute in the very first deploy.

```
cap example inaminute:first_deploy
```

This will execute `git clone` on the build server and the full steps of deploy.

Since capistrano-inaminute takes a Git-based strategy, `git fetch` and `git reset --hard origin/branch` will execute when called the `deploy` task.
Therefore, git repository needs to exist in the path application will be deployed before executing `git fetch` or any other git commands.

And also tasks configured to be executed only when the trigger files are changed never execute in the first deploy.
To avoid skipping them, `inaminute:first_deploy` confiugre `set :force_full_deploy, true`.
