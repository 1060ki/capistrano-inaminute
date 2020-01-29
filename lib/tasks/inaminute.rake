require 'capistrano/inaminute/git'

namespace :inaminute do
  def inaminute_git
    @inaminute_git ||= Capistrano::Inaminute::Git.new(self)
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
end
