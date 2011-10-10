require 'draper'

module WatchTower
  module Server
    module Decorator
      extend ::ActiveSupport::Autoload

      autoload :ApplicationDecorator
      autoload :ProjectDecorator
      autoload :FileDecorator
    end
  end
end

# Monkey Patch Draper
Draper::Base.class_eval <<-END, __FILE__, __LINE__ + 1
  def self.decorates(input)
    self.model_class = "::WatchTower::Server::\#{input.to_s.camelize}".constantize
    model_class.send :include, Draper::ModelSupport
  end
END