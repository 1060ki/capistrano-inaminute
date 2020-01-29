require 'capistrano/inaminute/git'
require 'capistrano/inaminute/rails'

namespace :inaminute do
  def inaminute_git
    @inaminute_git ||= Capistrano::Inaminute::Git.new(self)
  end

  def inaminute_rails
    @inaminute_rails ||= Capistrano::Inaminute::Rails.new(self)
  end

  namespace :git do
    task :clone_code do
      inaminute_git.clone_code
    end

    task :update_code do
      inaminute_git.update_code
    end

    task :tag do
      inaminute_git.tag
    end
  end

  namespace :bundle do
    task :install do
      trigger_changed = fetch(:inaminute_bundle_install_triggers).any? { |path| inaminute_git.is_changed?(path) }
      if trigger_changed
        inaminute_bundler.install
      else
        info "Skip `bundle install`. No change found in any of the triggers configured by `set :inaminute_bundle_install_triggers`"
      end
    end
  end

  namespace :assets do
    task :precompile do
      trigger_changed = fetch(:inaminute_assets_precompilation_triggers).any? { |path| inaminute_git.is_changed?(path) }
      if trigger_changed
        inaminute_rails.assets_precompile
      else
        info "Skip `rake assets:precompile`. No change found in any of the triggers configured by `set :inaminute_assets_precompilation_triggers`"
      end
    end
  end

  namespace :db do
    task :migrate do
      inaminute_rails.db_migrate
    end

    task :seed do
      inaminute_rails.db_seed
    end
  end
end

namespace :load do
  task :defaults do
    set :inaminute_bundle_install_triggers, %w{Gemfile Gemfile.lock}
    set :inaminute_bundle_install_opts, %w{--deployment --path vendor/bundle --without test development}
    set :inaminute_assets_precompilation_triggers, %w{app/assets config Gemfile.lock}
  end
end
