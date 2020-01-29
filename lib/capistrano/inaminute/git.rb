class Capistrano::Inaminute::Git < Capistrano::Inaminute::Base
  def clone_code
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :mkdir, "-p", fetch(:deploy_to)
        execute :git, "clone", fetch(:repo_url)
        execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
      end
    end
  end

  def update_code
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :git, "fetch"
        execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
      end
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