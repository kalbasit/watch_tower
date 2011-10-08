module WatchTower
  module Server
    module Presenters
      module Base

        def self.included(base)
          base.instance_eval <<-END, __FILE__, __LINE__ + 1
            # Add model_class as a class attribute
            class_attribute :model_class
            # Set the model_class
            self.model_class = "::WatchTower::Server::#{base.to_s.split('::').last}"

            # Override method missing to delegate undefined methods back to the
            # model
            #
            # @param [Symbol] The method name
            # @param [Array] Array of arguments
            # @param [&block] block
            def method_missing(method, *args, &block)
              if model_methods.include?(method)
                model.send(method, *args, &block)
              else
                super
              end
            end

            protected
              # Model Methods
              #
              # @return [Array]
              def model_methods
                model.public_methods.map{|s| s.to_sym}
              end

              # Get the model class
              #
              # @return [Class] The model class
              def model
                model_class.constantize
              end
          END
        end
      end
    end
  end
end