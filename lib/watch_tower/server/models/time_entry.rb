module WatchTower
  module Server
    class TimeEntry < ::ActiveRecord::Base
      PAUSE_TIME = 30.minutes

      validates :file_id, presence: true
      validates :mtime, presence: true

      belongs_to :file, counter_cache: true

      after_create :calculate_work_time

      protected
        def calculate_work_time
          # Gather information about this and last time entry for this file
          this_time_entry = self
          last_time_entry = file.time_entries.where('id < ?', this_time_entry.id).order('id DESC').first

          # Calculate the time difference (0 if cannot calculate)
          time_entry_elapsed = this_time_entry.mtime - last_time_entry.mtime rescue 0
          # Record the last time entry we looked at
          file.last_id = this_time_entry.id
          # Not to be added to elapsed_time if it is considered a PAUSE
          unless time_entry_elapsed > PAUSE_TIME
            # Add the time
            file.elapsed_time += time_entry_elapsed
            file.project.elapsed_time += time_entry_elapsed

            file.save
          end
        end

    end
  end
end