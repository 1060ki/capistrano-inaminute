class Capistrano::Inaminute::Rails < Capistrano::Inaminute::Base
  def assets_precompile
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :rake, "assets:precompile"
      end
    end
  end
end
