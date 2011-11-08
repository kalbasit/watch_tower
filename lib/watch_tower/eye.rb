# -*- encoding: utf-8 -*-

require 'digest/sha1'

module WatchTower
  module Eye
    extend self

    # Ignore paths
    IGNORED_PATHS = %r(/(.git|.svn)/)

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
            # Do not continue if no files were returned
            next unless files_paths && files_paths.respond_to?(:each)
            # Iterate over the files to fill the database
            files_paths.each do |file_path|
              begin
                next unless file_path
                LOG.debug("#{__FILE__}:#{__LINE__}: Ignoring #{file_path}") and next if file_path =~ IGNORED_PATHS
                LOG.debug("#{__FILE__}:#{__LINE__}: #{file_path} does not exist.") and next unless File.exists?(file_path)
                LOG.debug("#{__FILE__}:#{__LINE__}: #{file_path} is not a file") and next unless File.file?(file_path)
                # Get the file_hash of the file
                file_hash = Digest::SHA1.file(file_path).hexdigest
                LOG.debug("#{__FILE__}:#{__LINE__ - 1}: The hash of #{file_path} is #{file_hash}.")
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
                LOG.debug("#{__FILE__}:#{__LINE__ - 1}: Created (or fetched) the project with the id #{project_model.id}")

                # Create (or fetch) a file
                file_model = project_model.files.find_or_create_by_path(file_path)
                LOG.debug("#{__FILE__}:#{__LINE__ - 1}: Created (or fetched) the file with the id #{file_model.id}")
                begin
                  # Create a time entry
                  time_entry_model =  file_model.time_entries.create! mtime: ::File.stat(file_path).mtime,
                    file_hash: file_hash,
                    editor_name: editor.name,
                    editor_version: editor.version
                  LOG.debug("#{__FILE__}:#{__LINE__ - 4}: Created a time_entry with the id #{time_entry_model.id}")
                rescue ActiveRecord::RecordInvalid => e
                  if e.message =~ /Validation failed: Mtime has already been taken/
                    # This should happen if the mtime is already present
                    LOG.debug("#{__FILE__}:#{__LINE__ - 8}: The time_entry already exists, nothing were created, error message is #{e.message}")
                  elsif e.message =~ /Validation failed: /
                    # This should not happen
                    LOG.fatal("#{__FILE__}:#{__LINE__ - 11}: The time_entry did not pass validations, #{e.message}.")
                    $close_eye = true
                  else
                    # Some other error happened
                    LOG.fatal("#{__FILE__}:#{__LINE__ - 15}: An unknown error has been raised while creating the time_entry, #{e.message}")
                    $close_eye = true
                  end
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
        end unless $pause_eye

        # If $stop global is set, please stop, otherwise sleep for 10 seconds.
        if $close_eye
          LOG.debug("#{__FILE__}:#{__LINE__}: Closing eye has been requested, end the loop")
          break
        else
          # TODO: This should be in the config file, let the user decide how often the loop should start
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
