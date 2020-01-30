require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Rails < Capistrano::Inaminute::Base
  def assets_precompile
    within fetch(:inaminute_local_release_path) do
      Bundler.with_clean_env do
        execute :bundle, "exec", "rake", "assets:precompile"
      end
    end
  end

  def db_migrate
    within fetch(:inaminute_local_release_path) do
      with rails_env: fetch(:rails_env) do
        Bundler.with_clean_env do
          execute :bundle, "exec", "rake", "db:create"
          execute :bundle, "exec", "rake", "db:migrate"
        end
      end
    end
  end
end

def db_seed
  within fetch(:inaminute_local_release_path) do
    with rails_env: fetch(:rails_env) do
      Bundler.with_clean_env do
        execute :bundle, "exec", "rake", "db:seed"
      end
    end
  end
end
