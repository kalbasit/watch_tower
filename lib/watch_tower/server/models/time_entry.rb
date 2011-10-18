module WatchTower
  module Server
    class TimeEntry < ::ActiveRecord::Base

      # Default pause time, in case nothing was given in the config file
      DEFAULT_PAUSE_TIME = 30.minutes

      # Validations
      validates :file_id, presence: true
      validates :mtime, presence: true
      validates_uniqueness_of :mtime, scope: :file_id
      validates :file_hash, presence: true
      validates :editor_name, presence: true
      validates :editor_version, presence: true


      # Associations
      belongs_to :file, counter_cache: true
      has_many :durations

      # Callbacks
      after_create :calculate_elapsed_time

      protected
        # Calculate the elapsed time between this time entry and the last one
        # then update the durations table with the time difference, either by
        # updating the duration for this day or by creating a new one for the
        # next day
        def calculate_elapsed_time
          # Gather information about this and last time entry for this file
          this_time_entry = self
          last_time_entry = file.time_entries.where('id < ?', this_time_entry.id).order('id DESC').first
          # Check the hash first
          return if this_time_entry.file_hash == last_time_entry.try(:file_hash)
          # Update the file's hash
          file.file_hash = this_time_entry.file_hash
          # Parse the date of the mtime
          this_time_entry_date = self.mtime.to_date
          last_time_entry_date = last_time_entry.mtime.to_date rescue nil
          # Act upon the date
          if this_time_entry_date == last_time_entry_date
            # Calculate the time
            time_entry_elapsed = this_time_entry.mtime - last_time_entry.mtime rescue 0
            unless time_entry_elapsed > pause_time
              # Update the file elapsed time
              file.elapsed_time += time_entry_elapsed
              # Update the project's elapsed time
              file.project.elapsed_time += time_entry_elapsed
              # Add this time to the durations table
              d = file.durations.find_or_create_by_date(this_time_entry_date)
              d.duration += time_entry_elapsed
              d.save
            end
          end

          # Save the file and project
          file.save
          file.project.save
        end

        # Get the
        def pause_time
          eval(Config[:pause_time]) rescue DEFAULT_PAUSE_TIME
        end
    end
  end
end