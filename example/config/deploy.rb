# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "example"
set :repo_url, "git@github.com:grezar/capistrano-inaminute.git"
set :branch, ENV["BRANCH"] || "master"
set :deploy_to, "/home/vagrant/#{fetch(:application)}"
set :rbenv_type, :user
set :rbenv_ruby, '2.7.0'

set :inaminute_local_release_path, fetch(:deploy_to)
set :inaminute_release_roles, %w{web}
