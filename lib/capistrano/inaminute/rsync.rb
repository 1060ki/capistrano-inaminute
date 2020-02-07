class Capistrano::Inaminute::Rsync < Capistrano::Inaminute::Base
  def rsync
    hosts = roles(fetch(:inaminute_release_roles))
    max_parallel_hosts = fetch(:inaminute_max_parallel_hosts) || hosts.size

    Parallel.each(hosts, in_threads: max_parallel_hosts) do |host|
      execute :rsync, "-au", "--delete", "#{fetch(:inaminute_local_release_path)}/", "#{host}:#{fetch(:deploy_to)}", fetch(:inaminute_rsync_options)
    end
  end
end
