require 'capistrano/inaminute/base'

class Capistrano::Inaminute::Git < Capistrano::Inaminute::Base
  GIT_TAG_PREFIX = "inaminute-release"

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
    within fetch(:inaminute_local_release_path) do
      execute :git, "fetch"
      execute :git, "reset", "--hard", "origin/#{fetch(:branch)}"
    end
  end

  def set_current_revision
    within fetch(:inaminute_local_release_path) do
      set :current_revision, capture(:git, "rev-parse HEAD")
    end
  end

  def tag
    within fetch(:inaminute_local_release_path) do
      execute :git, "tag", "#{GIT_TAG_PREFIX}-#{Time.now.strftime("%Y%m%d%H%M%S")}"
    end
  end

  def have_diff?(triggers)
    return true if fetch(:inaminute_force_full_deploy)

    triggers = triggers.is_a?(Array) ? triggers : [triggers]

    triggers.any? do |path|
      fetch(:changed_files).detect { |p| p == path }
    end
  end

  def set_changed_files
    within fetch(:inaminute_local_release_path) do
      if fetch(:latest_tag)
        set_if_empty :changed_files, capture(:git, "diff", "--name-only", fetch(:latest_tag), "origin/#{fetch(:branch)}").split
      else
        set_if_empty :changed_files, capture(:git, "ls-files").split
      end
    end
  end

  def set_latest_tag
    within fetch(:inaminute_local_release_path) do
      set :latest_tag, capture(:git, "tag").split.select { |t| t.start_with?(GIT_TAG_PREFIX) }.last
    end
  end

  def revert_to_latest_tag
    within fetch(:inaminute_local_release_path) do
      if fetch(:latest_tag)
        execute :git, "reset", "--hard", fetch(:latest_tag)
      else
        info "Nothing to do. This may be the first release due to any git tag is not found"
      end
    end
  end

  def delete_latest_tag
    within fetch(:inaminute_local_release_path) do
      execute :git, "tag", "-d", fetch(:latest_tag) if fetch(:latest_tag)
    end
  end
end
