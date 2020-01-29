class Capistrano::Inaminute::Bundler < Capistrano::Inaminute::Base
  def install
    hosts = release_roles(:all)
    on hosts do
      within release_path do
        execute :bundle, "install", fetch(:inaminute_bundle_install_opts)
      end
    end
  end
end
