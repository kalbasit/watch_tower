module WatchTower
  module Editor
    class Textmate
      include BaseAppscript

      # Returns the name of the editor
      #
      # @return [String] The editor's name
      def name
        "Textmate"
      end

      protected
        # This method returns an instance of ::Appscript::Application
        #
        # returns [::Appscript::Application | nil]
        def editor
          app 'Textmate'
        rescue ::FindApp::ApplicationNotFoundError
          LOG.debug "#{__FILE__}:#{__LINE__ - 2}: Textmate application can't be found, maybe not installed?"
        end
    end
  end
end