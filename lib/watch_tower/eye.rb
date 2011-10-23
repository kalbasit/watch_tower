# -*- encoding: utf-8 -*-

require 'digest/sha1'

module WatchTower
  module Eye
    extend self

    # Start the watch loop
    #
    # @param [Hash] options
    # @raise [EyeError]
    def start(options = {})
      LOG.debug("#{__FILE__}:#{__LINE__}: The Eye loop has just started")
      loop do
        # Try getting the mtime of the document opened by each editor in the
        # editors list.
        Editor.editors.each do |editor|
          # Create an instance of the editor
          # TODO: Should be used as a class instead
          editor = editor.new
          # Check if the editor is running
          if editor.is_running?
            LOG.debug("#{__FILE__}:#{__LINE__}: #{editor.to_s} is running")
            # Get the currently being edited file from the editor
            files_paths = editor.current_paths
            # Iterate over the files to fill the database
            files_paths.each do |file_path|
              begin
                next unless file_path && File.exists?(file_path)
                next if file_path =~ %r(/.git/)
                # Get the file_hash of the file
                file_hash = Digest::SHA1.file(file_path).hexdigest
                # Create a project from the file_path
                project = Project.new_from_path(file_path)
              rescue PathNotUnderCodePath
                LOG.debug("#{__FILE__}:#{__LINE__ - 2}: The file '#{file_path}' is not located under '#{Config[:code_path]}', it has been ignored")
                next
              rescue FileNotFound
                LOG.debug "#{__FILE__}:#{__LINE__ - 5}: The file '#{file_path}' does not exist, it has been ignored"
                next
              end

              begin
                # Create (or fetch) a project
                project_model = Server::Project.find_or_create_by_name_and_path(project.name, project.path)

                # Create (or fetch) a file
                file_model = project_model.files.find_or_create_by_path(file_path)
                begin
                  # Create a time entry
                  file_model.time_entries.create! mtime: File.stat(file_path).mtime,
                    file_hash: file_hash,
                    editor_name: editor.name,
                    editor_version: editor.version
                rescue ActiveRecord::RecordInvalid => e
                  # This should happen if the mtime is already present
                end
              rescue ActiveRecord::RecordInvalid => e
                # This should not happen
                LOG.fatal("#{__FILE__}:#{__LINE__}: #{e}")
                $close_eye = true
              end
            end
          else
            LOG.debug("#{__FILE__}:#{__LINE__}: #{editor.to_s} is not running")
          end
        end

        # If $stop global is set, please stop, otherwise sleep for 10 seconds.
        if $close_eye
          LOG.debug("#{__FILE__}:#{__LINE__}: Closing eye has been requested, end the loop")
          break
        else
          sleep 10
        end
      end
    end

    # Start the Eye, a method invoked from the Watch Tower command line interface
    #
    # @param [Hash] options
    def start!(options = {})
      # Signal handling
      Signal.trap("INT")  { $close_eye = true }
      Signal.trap("TERM") { $close_eye = true }

      start(options)
    end
  end
end