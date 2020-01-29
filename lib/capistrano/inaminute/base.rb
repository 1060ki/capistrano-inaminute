require 'delegate'

class Capistrano::Inaminute::Base < SimpleDelegator
  def initialize(delegator)
    super(delegator)
  end
end
