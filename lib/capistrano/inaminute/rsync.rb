class Capistrano::Inaminute::Rsync < Capistrano::Inaminute::Base
  def rsync
    hosts = release_roles(:web)
    opts = fetch(:inaminute_rsync_options)
    Parallel.each(hosts, in_threads: fetch(:inaminute_max_parallel_hosts)) do |host|
      execute :rsync, "-au", "--delete", "#{fetch(:inaminute_local_release_path)}/", "#{host}:#{fetch(:deploy_to)}"
    end
  end
end
