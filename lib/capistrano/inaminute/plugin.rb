require 'capistrano/inaminute'
require 'capistrano/scm/plugin'

class Capistrano::Inaminute::Plugin < Capistrano::SCM::Plugin
  def register_hooks
    after "deploy:new_release_path", "inaminute:create_release"
    before "deploy:check", "inaminute:check"
    before "deploy:set_current_revision", "inaminute:set_current_revision"
  end
end
