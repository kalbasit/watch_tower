module WatchTower
  module Server
    module Presenters
      class ApplicationPresenter

        attr_reader :model, :template

        # Presents a model
        #
        # @param [Symbol] name
        def self.presents(name)
          define_method name do
            @model
          end
        end

        # Initialise the presenter
        #
        # @param [ActiveRecord::Base] Model
        # @param [Object] Template
        def initialize(model, template)
          @model = model
          @template = template
        end

        # Overwrite Kernel#method_missing to invoke either the model or the
        # template's method if present, if not Kernel#method_missing will be
        # called
        #
        # @param [Symbol] method: The method name
        # @param [Array] arguments
        # @param [Block]
        def method_missing(method, *args, &block)
          if model.respond_to?(method)
            model.send(method, *args, &block)
          elsif template.respond_to?(method)
            template.send(method, *args, &block)
          else
            super
          end
        end

        # Returns a human formatted time
        #
        # @param [Integer] elapsed_time
        # @return [String] The elapsed time formatted
        def elapsed(elapsed_time = nil)
          return "" if elapsed_time.nil? && !model.respond_to?(:elapsed_time)
          elapsed_time ||= model.elapsed_time
          humanize_time elapsed_time
        end

        protected
          def pluralize(num, word)
            if num > 1
              "#{num} #{word.pluralize}"
            else
              "#{num} #{word}"
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

          [:day, :hour, :minute].each do |t|
            class_eval <<-END, __FILE__, __LINE__ + 1
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