require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Bundler < Capistrano::Inaminute::Base
  def install
    within fetch(:inaminute_local_release_path) do
      execute :bundle, "install", fetch(:inaminute_bundle_install_opts)
    end
  end
end
