module WatchTower
  module Server
    module Extensions
      module ImprovedPartials

        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          # Render a partial with support for collections
          #
          # stolen from http://github.com/cschneid/irclogger/blob/master/lib/partials.rb
          #   and made a lot more robust by Sam Elliott <sam@lenary.co.uk>
          #   https://gist.github.com/119874
          #
          # @param [Symbol] The template to render
          # @param [Hash] Options
          def partial(template, *args)
            template_array = template.to_s.split('/')
            template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
            options = args.last.is_a?(Hash) ? args.pop : {}
            options.merge!(:layout => false)
            if collection = options.delete(:collection) then
              collection.inject([]) do |buffer, member|
                buffer << haml(:"#{template}", options.merge(:layout =>
                false, :locals => {template_array[-1].to_sym => member}))
              end.join("\n")
            else
              haml(:"#{template}", options)
            end
          end
        end
      end
    end
  end
end