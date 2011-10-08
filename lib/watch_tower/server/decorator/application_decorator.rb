module WatchTower
  module Server
    module Decorator
      class ApplicationDecorator < Draper::Base

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

        # Lazy Helpers
        #   PRO: Call Rails helpers without the h. proxy
        #        ex: number_to_currency(model.price)
        #   CON: Add a bazillion methods into your decorator's namespace
        #        and probably sacrifice performance/memory
        #
        #   Enable them by uncommenting this line:
        #   lazy_helpers

        # Shared Decorations
        #   Consider defining shared methods common to all your models.
        #
        #   Example: standardize the formatting of timestamps
        #
        #   def formatted_timestamp(time)
        #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
        #                   :class => 'timestamp'
        #   end
        #
        #   def created_at
        #     formatted_timestamp(model.created_at)
        #   end
        #
        #   def updated_at
        #     formatted_timestamp(model.updated_at)
        #   end
      end
    end
  end
end