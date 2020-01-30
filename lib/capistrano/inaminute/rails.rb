require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Rails < Capistrano::Inaminute::Base
  def assets_precompile
    within release_path do
      execute :rake, "assets:precompile"
    end
  end

  def db_migrate
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "db:create"
        execute :rake, "db:migrate"
      end
    end
  end
end

def db_seed
  within release_path do
    with rails_env: fetch(:rails_env) do
      execute :rake, "db:seed"
    end
  end
end
