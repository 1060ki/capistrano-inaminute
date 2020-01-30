require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Git < Capistrano::Inaminute::Base
  def check
    exit 1 unless execute("git ls-remote #{repo_url} HEAD")
    execute :mkdir, "-p", fetch(:deploy_to)
  end

  def clone
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :git, "clone", fetch(:repo_url), fetch(:deploy_to)
        execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
      end
    end
  end

  def update
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :git, "fetch"
        execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
      end
    end
  end

  def create_release
    execute :mkdir, "-p", release_path
  end

  def set_current_revision
    within release_path do
      set :current_revision, capture(:git, "rev-list --max-count=1 #{fetch(:branch)}")
    end
  end

  def tag
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :git, "tag", release_tag
      end
    end
  end

  def is_changed?(path)
    changed_files.any? { |p| p == path }
  end

  private

  def changed_files
    @changed_files ||= (capture :git, "ls-files", "-m").split
  end
end
