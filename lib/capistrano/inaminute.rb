require "capistrano/framework"

module Capistrano
  module Inaminute
  end
end

load File.expand_path('../tasks/deploy.rake', __FILE__)
load File.expand_path('../tasks/inaminute.rake', __FILE__)
