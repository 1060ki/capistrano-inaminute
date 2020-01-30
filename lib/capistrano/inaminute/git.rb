require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Git < Capistrano::Inaminute::Base
  def create_release
    execute :mkdir, "-p", fetch(:inaminute_local_release_path)
  end

  def clone
    within fetch(:inaminute_local_release_path) do
      execute :git, "clone", fetch(:repo_url), fetch(:inaminute_local_release_path), "-b", "#{fetch(:branch)}"
      execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
    end
  end

  def update
    hosts = release_roles(:all)
    on hosts do
      within fetch(:inaminute_local_release_path) do
        execute :git, "fetch"
        execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
      end
    end
  end

  def set_current_revision
    within fetch(:inaminute_local_release_path) do
      set :current_revision, capture(:git, "rev-parse HEAD")
    end
  end

  def tag
    hosts = release_roles(:all)
    on hosts do
      within fetch(:inaminute_local_release_path) do
        execute :git, "tag", fetch(:inaminute_release_tag)
      end
    end
  end

  def is_changed?(path)
    fetch(:changed_files).any? { |p| p == path }
  end
end
