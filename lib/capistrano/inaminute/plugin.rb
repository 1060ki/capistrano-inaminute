require 'capistrano/inaminute'
require 'capistrano/scm/plugin'

class Capistrano::Inaminute::Plugin < Capistrano::SCM::Plugin
  def register_hooks
    # Do nothing here
  end
end
