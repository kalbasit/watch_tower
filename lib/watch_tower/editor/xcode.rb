module WatchTower
  module Editor
    class Xcode
      include BaseAppscript

      # Define the application as a class instance
      @@app = begin
        # Cannot use app('Xcode') because it fails when multiple Xcode versions are installed
        # Taken from timetap
        # https://github.com/apalancat/timetap/blob/editors/lib/time_tap/editors.rb#L25
        pid = app('System Events').processes[its.name.eq('Xcode')].first.unix_id.get
        app.by_pid(pid)
      rescue
        nil
      end
    end
  end
end