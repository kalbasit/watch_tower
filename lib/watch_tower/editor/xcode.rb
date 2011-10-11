module WatchTower
  module Editor
    class Xcode
      include BaseAppscript

      protected
        # This method returns an instance of ::Appscript::Application
        #
        # returns [::Appscript::Application | nil]
        def editor
          # Cannot use app('Xcode') because it fails when multiple Xcode versions are installed
          # Taken from timetap
          # https://github.com/apalancat/timetap/blob/editors/lib/time_tap/editors.rb#L25
          pid = app('System Events').processes[its.name.eq('Xcode')].first.unix_id.get
          app.by_pid(pid)
        rescue ::FindApp::ApplicationNotFoundError
        rescue ::Appscript::CommandError
          nil
        end
    end
  end
end