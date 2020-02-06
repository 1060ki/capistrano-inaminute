namespace :deploy do
  task :starting do
    invoke "inaminute:git:create_release"
  end

  task :updating do
    if fetch(:inaminute_first_deploy)
      invoke "inaminute:git:clone"
    else
      invoke "inaminute:git:update"
    end
    invoke "inaminute:git:set_latest_tag"
    invoke "inaminute:git:set_changed_files"
    invoke "deploy:set_current_revision"
    invoke "inaminute:git:tag"
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
