# -*- encoding: utf-8 -*-

module WatchTower
  module Editor
    class Textmate
      include BaseAppscript

      protected
        # This method returns an instance of ::Appscript::Application
        #
        # returns [::Appscript::Application | nil]
        def editor
          app 'Textmate'
        rescue AppscriptNotLoadedError
          # This is expected if appscriot not loaded, on linux for example
        rescue ::FindApp::ApplicationNotFoundError
          LOG.debug "#{__FILE__}:#{__LINE__ - 4}: Textmate application can't be found, maybe not installed?"
          nil
        rescue ::Appscript::CommandError => e
          LOG.error "#{__FILE__}:#{__LINE__ - 7}: Command error #{e}"
          nil
        end
    end
  end
end
