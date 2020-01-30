# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "example"
set :repo_url, "git@github.com:grezar/capistrano-inaminute.git"
set :branch, ENV["BRANCH"] || "master"
set :deploy_to, "#{ENV["HOME"]}/#{fetch(:application)}"

set :inaminute_local_release_path, fetch(:deploy_to)
