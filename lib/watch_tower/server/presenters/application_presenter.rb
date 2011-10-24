# -*- encoding: utf-8 -*-

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

        # Returns an approximate elapsed time
        #
        # @param [Integer] elapsed_time
        # @return [String] The approximate elapsed time
        def approximate_elapsed(elapsed_time = nil)
          return "" if elapsed_time.nil? && !model.respond_to?(:elapsed_time)
          elapsed_time ||= model.elapsed_time

          if elapsed_time > 1.day
            elapsed_t = (elapsed_time / 1.day).to_i * 1.day
            elapsed_f = elapsed(elapsed_t)

            if elapsed_time % 1.day >= 20.hours
              elapsed(elapsed_t + 1.day)
            elsif elapsed_time % 1.day >= 5.hours
              "#{elapsed_f} and a half"
            else
              elapsed_f
            end
          elsif elapsed_time > 1.hour
            elapsed_t = (elapsed_time / 1.hour).to_i * 1.hour
            elapsed_f = elapsed(elapsed_t)

            if elapsed_time % 1.hour >= 50.minutes
              elapsed(elapsed_t + 1.hour)
            elsif elapsed_time % 1.hour >= 25.minutes
              "#{elapsed_f} and a half"
            else
              elapsed_f
            end
          elsif elapsed_time > 60.seconds
            elapsed_time = (elapsed_time / 60).to_i * 60
            elapsed(elapsed_time)
          else
            '1 minute'
          end
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

          # Parse a file tree
          #
          # @param [FileTree] tree
          # @param [Boolean] root
          # @return [String] HTML of the file tree
          def parse_file_tree(tree, root = false)
            # Create the root element
            if root
              html = '<article class="file_tree">'
              html << '<div id="root" class="folder">'
            else
              folder_name = ::File.basename(tree.base_path)
              html = %(<div id="nested_#{folder_name}" class="nested_folder">)
            end
            # Open the wrapper
            html << '<div class="folder_wrapper">'
            # Add the collapsed span
            html << '<span class="collapsed">+</span>'
            # Add the name
            if root
              html << '<span class="name">Project</span>'
            else
              html << %(<span class="name">#{folder_name}</span>)
            end
            # Add the elapsed time
            html << %(<span class="elapsed_time">#{elapsed(tree.elapsed_time)}</span>)
            # End with a clearfix element
            html << '<div class="clearfix"></div>'
            # Close the wrapper
            html << '</div>'
            # Add the nested_tree if available
            if tree.nested_tree.any?
              tree.nested_tree.each_pair do |folder, nested_tree|
                html << parse_file_tree(nested_tree)
              end
            end
            # Add the files
            if tree.files.any?
              # Open the files 's ul
              html << '<ul class="files">'
              tree.files.each do |file|
                # Open the file's li
                html << '<li class="file">'
                # Add the path
                html << %(<span class="path">#{file[:path]}</span>)
                # Add the elapsed time
                html << %(<span class="elapsed_time">#{elapsed(file[:elapsed_time])}</span>)
                # End with a clearfix element
                html << '<div class="clearfix"></div>'
                # Close the file's li
                html << '</li>'
              end
              # Close the files 's ul
              html << '</ul>'
            end
            # Close the root div
            html << "</div>"
            # Clode the article if it is the root element
            html << "</article>" if root
            # Finally return the whole thing
            html
          end
      end
    end
  end
end