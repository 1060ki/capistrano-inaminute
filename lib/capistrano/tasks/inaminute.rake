require 'capistrano/inaminute/git'
require 'capistrano/inaminute/bundler'
require 'capistrano/inaminute/rsync'
require 'parallel'

namespace :inaminute do
  def inaminute_git
    @inaminute_git ||= Capistrano::Inaminute::Git.new(self)
  end

  def inaminute_bundler
    @inaminute_bundler ||= Capistrano::Inaminute::Bundler.new(self)
  end

  def inaminute_rsync
    @inaminute_rsync ||= Capistrano::Inaminute::Rsync.new(self)
  end

  task :check_local_release_path do
    on release_roles(:build) do
      if test "[ ! -d #{fetch(:inaminute_local_release_path)} ]"
        info "First deploy"
        set :inaminute_first_deploy, true
      end
    end
  end

  namespace :git do
    task :create_release do
      on release_roles(:all) do
        inaminute_git.create_release
      end
    end

    task :set_current_revision do
      on roles(:build) do
        inaminute_git.set_current_revision
      end
    end
    before "deploy:set_current_revision", "inaminute:git:set_current_revision"

    task :tag do
      on roles(:build) do
        inaminute_git.tag
      end
    end

    task :clone do
      on roles(:build) do
        inaminute_git.clone
      end
    end

    task :update do
      on roles(:build) do
        inaminute_git.update
      end
    end

    task :set_changed_files do
      on roles(:build) do
        inaminute_git.set_changed_files
      end
    end

    task :set_latest_tag do
      on roles(:build) do
        inaminute_git.set_latest_tag
      end
    end

    task :delete_latest_tag do
      on roles(:build) do
        inaminute_git.delete_latest_tag
      end
    end

    task :revert do
      on roles(:build) do
        inaminute_git.revert_to_latest_tag
      end
    end
  end

  namespace :bundle do
    task :install do
      if inaminute_git.have_diff? fetch(:inaminute_bundle_install_triggers)
        on roles(:build) do
          inaminute_bundler.install
        end
      end
    end
  end
  after "deploy:updated", "inaminute:bundle:install"

  task :rsync do
    on roles(:build) do
      inaminute_rsync.rsync
    end
  end
  before "deploy:publishing", "inaminute:rsync"
end

namespace :load do
  task :defaults do
    set :inaminute_release_tag, Time.now.strftime("%Y%m%d%H%M%S")
    set :inaminute_bundle_install_triggers, %w{Gemfile Gemfile.lock}
    set :inaminute_bundle_install_opts, %w{--deployment --path vendor/bundle --without test development}
  end
end
