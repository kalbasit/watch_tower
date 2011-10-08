module WatchTower
  module Server
    module Presenter
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

          base.class_eval <<-END, __FILE__, __LINE__ + 1
            protected
              def pluralize(num, word)
                if num > 1
                  "\#{num} \#{word.pluralize}"
                else
                  "\#{num} \#{word}"
                end
              end

              # Humanize time
              #
              # @param [Integer] The number of seconds
              # @return [String]
              def humanize_time(time)
                case
                when time >= 1.day
                  humanize_day(time)
                when time >= 1.hour
                  humanize_hour(time)
                when time >= 1.minute
                  humanize_minute(time)
                else
                  pluralize time, "second"
                end
              end
          END

          [:day, :hour, :minute].each do |t|
            base.class_eval <<-END, __FILE__, __LINE__ + 1
              protected
                def humanize_#{t}(time)
                  seconds = 1.#{t}
                  num = (time / seconds).to_i
                  rest = time % seconds

                  time_str = pluralize num, "#{t}"

                  unless rest == 0
                    "\#{time_str}#{t == :minute ? ' and' : ','} \#{humanize_time(rest)}"
                  else
                    time_str
                  end
                end
            END
          end

        end
      end
    end
  end
end