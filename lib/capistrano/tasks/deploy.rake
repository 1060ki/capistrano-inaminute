namespace :deploy do
  task :starting do
    invoke "inaminute:check:build_server"
    invoke "inaminute:check:local_release_path"
    invoke "inaminute:git:create_release"
  end

  task :updating do
    if fetch(:inaminute_first_deploy)
      invoke "inaminute:git:clone"
      set :inaminute_force_full_deploy, true
    else
      invoke "inaminute:git:update"
    end
    invoke "inaminute:git:set_latest_tag"
    invoke "inaminute:git:set_changed_files"
    invoke "deploy:set_current_revision"
  end

  task :publishing do
    invoke "inaminute:git:tag"
    invoke "inaminute:rsync"
  end

  task :reverting do
    invoke "inaminute:git:set_latest_tag"
    invoke "inaminute:git:delete_latest_tag"
    invoke! "inaminute:git:set_latest_tag"
    invoke "inaminute:git:revert"
  end

  task :set_current_revision do
    on roles(:build) do
      within fetch(:inaminute_local_release_path) do
        execute :echo, "\"#{fetch(:current_revision)}\" > REVISION"
      end
    end
  end
end
