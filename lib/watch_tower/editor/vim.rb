# -*- encoding: utf-8 -*-
require 'systemu'

module WatchTower
  module Editor
    class Vim
      include BasePs

      VIM_EXTENSION_PATH = File.join(EDITOR_EXTENSIONS_PATH, 'watchtower.vim')

      def initialize
        # Get the list of supported vims
        supported_vims
      end

      # Return the name of the Editor
      #
      # @return [String] The editor's name
      def name
        "Vim"
      end

      # Return the version of the editor
      #
      # @return [String] The editor's version
      def version
        status, stdout, stderr = systemu "#{@vims.first} --version" if @vims.any?

        stdout.scan(/^VIM - Vi IMproved (\d+\.\d+).*/).first.first
      end

      # Is it running ?
      #
      # @return [Boolean] Is ViM running ?
      def is_running?
        servers.any?
      end

      # Return the open documents of all vim servers
      #
      # @return [Array] Absolute paths to all open documents
      def current_paths
        if is_running?
          documents = []
          servers.each do |server|
            status, stdout, stderr = systemu "#{editor} --servername #{server} --remote-expr 'watchtower#ls()'"

            stdout.split("\n").each do |doc|
              documents << doc.scan(/^\(\d+\)\s+(.*)$/).first.first
            end
          end

          documents
        end
      end

      protected
      # Return a list of supported vim commands
      #
      # @return [Array] A list of supported vim commands.
      def supported_vims
        @vims ||= ['mvim', 'gvim', 'vim'].collect do |vim|
          # Get the absolute path of the command
          vim_path = WatchTower.which(vim)
          # Print the help of the command
          status, stdout, stderr = systemu "#{vim_path} --help" if vim_path
          # This command is compatible if it exists and if it respond to --remote
          # TODO: Remove the mvim/gvim exclusion on stdout comparision
          #       This does not work on my box (OpenSuse), somehow stdout is
          #       empty for gvim
          vim_path && (vim == 'gvim' || stdout =~ %r(--remote) ) ? vim_path : nil
        end.reject { |vim| vim.nil? }
      end

      # Return the editor
      #
      # @return [String|nil] The editor command
      def editor
        @vims.any? && @vims.first
      end

      # Returns the running servers
      #
      # @return [Array] Name of running ViM Servers
      def servers
        status, stdout, stderr = systemu "#{editor} --serverlist"
        stdout.split("\n")
      end

      # Send WatchTower extensions to vim
      def send_extensions_to_editor
        servers.each do |server|
          systemu "#{editor} --servername #{server} --remote-send ':source #{VIM_EXTENSION_PATH}<CR>'"
        end
      end
    end
  end
end
