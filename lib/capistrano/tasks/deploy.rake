namespace :deploy do
  task :starting do
    invoke "inaminute:git:create_release"
  end

  task :updating do
    invoke "inaminute:git:update"
    invoke "deploy:set_current_revision"
  end

  task :finishing do
    invoke "inaminute:git:tag"
  end

  task :set_current_revision do
    on roles(:build) do
      within fetch(:inaminute_local_release_path) do
        execute :echo, "\"#{fetch(:current_revision)}\" > REVISION"
      end
    end
  end
end
