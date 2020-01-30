require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Rails < Capistrano::Inaminute::Base
  def assets_precompile
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :rake, "assets:precompile"
      end
    end
  end

  def db_migrate
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
          execute :rake, "db:migrate"
        end
      end
    end
  end

  def db_seed
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end
end
