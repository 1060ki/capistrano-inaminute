require 'capistrano/inaminute/git'
require 'capistrano/inaminute/rails'

namespace :inaminute do
  def inaminute_git
    @inaminute_git ||= Capistrano::Inaminute::Git.new(self)
  end

  def inaminute_rails
    @inaminute_rails ||= Capistrano::Inaminute::Rails.new(self)
  end

  task :setup do
    invoke "inaminute:git:create_release"
    invoke "inaminute:git:clone"
    invoke "inaminute:git:set_current_revision"
  end

  namespace :git do
    task :create_release do
      on release_roles(:all) do
        inaminute_git.create_release
      end
    end

    task :set_current_revision do
      run_locally do
        inaminute_git.set_current_revision
      end
    end
    before "deploy:set_current_revision", "inaminute:git:set_current_revision"

    task :tag do
      run_locally do
        inaminute_git.tag
      end
    end

    task :clone do
      run_locally do
        inaminute_git.clone
      end
    end

    task :update do
      run_locally do
        inaminute_git.update
      end
    end

    task :set_changed_files do
      run_locally do
        set :changed_files, capture(:git, "ls-files", "-m").split
      end
    end
    after "deploy:updated", "inaminute:git:set_changed_files"
  end

  namespace :bundle do
    task :install do
      trigger_changed = fetch(:inaminute_bundle_install_triggers).any? { |path| inaminute_git.is_changed?(path) }
      if fetch(:inaminute_force_full_deploy) || trigger_changed
        run_locally do
          inaminute_bundler.install
        end
      end
    end
  end
  after "deploy:updated", "inaminute:bundle:install"

  namespace :assets do
    task :precompile do
      trigger_changed = fetch(:inaminute_assets_precompilation_triggers).any? { |path| inaminute_git.is_changed?(path) }
      if fetch(:inaminute_force_full_deploy) || trigger_changed
        run_locally do
          inaminute_rails.assets_precompile
        end
      end
    end
  end

  namespace :db do
    task :migrate do
      on primary fetch(:migration_role) do
        inaminute_rails.db_migrate
      end
    end

    task :seed do
      on primary fetch(:migration_role) do
        inaminute_rails.db_seed
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :inaminute_release_tag, Time.now.strftime("%Y%m%d%H%M%S")
    set :inaminute_bundle_install_triggers, %w{Gemfile Gemfile.lock}
    set :inaminute_bundle_install_opts, %w{--deployment --path vendor/bundle --without test development}
    set :inaminute_assets_precompilation_triggers, %w{app/assets config Gemfile.lock}
  end
end
