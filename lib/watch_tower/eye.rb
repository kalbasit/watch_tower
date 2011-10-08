module WatchTower
  module Eye
    extend self

    # Start the watch loop
    #
    # @raise [EyeError]
    def start
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
            files_paths.each do |file_path|
              # Create a project from the file_path
              project = Project.new_from_path(file_path)
              # Create (or fetch) a project
              project_model = Server::Project.find_or_create_by_name_and_path(project.name, project.path)
              # Create (or fetch) a file
              file_model = project_model.files.find_or_create_by_path(file_path)
              begin
                # Create a time entry
                file_model.time_entries.create!(mtime: File.stat(file_path).mtime)
              rescue ActiveRecord::RecordInvalid => e
                # This shouldn't happen!
                LOG.debug "#{__FILE__}:#{__LINE__ - 3}: #{e}"
              end
            end
          else
            LOG.debug("#{__FILE__}:#{__LINE__}: #{editor.to_s} is not running")
          end
        end

        # If $stop global is set, please stop, otherwise sleep for 30 seconds.
        if $close_eye
          break
        else
          sleep 1
        end
      end
    end

    # Start the Eye, a method invoked from the Watch Tower command line interface
    #
    # @param [Hash] options
    def start!(options = {})
      @thread = Thread.new do
        # Trap INT and TERM to quit the thread
        Signal.trap("INT")  { exit }
        Signal.trap("TERM") { exit }

        # Start the loop
        start

        # Exit right after the loop ended (for some reason)
        exit
      end
    end
  end
end