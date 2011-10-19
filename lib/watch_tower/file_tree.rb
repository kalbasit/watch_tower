module WatchTower
  # This class is used by the server to provided a FileTree representation
  # of the files and their elapsed time
  class FileTree

    attr_reader :files, :tree

    # Initialize
    #
    # @param [String] base_path: The base path of all files, usually the project's path
    # @param [Array] files: The files and their elapsed time
    #                The Array elements should be Hashes with two required keys
    #                :path and :elapsed_time
    def initialize(base_path, files)
      @base_path = base_path
      @files = files
    end

    # Render the FileTree
    #
    # @return [Array] The FileTree representation
    def render
    end

    protected
      def remove_base_path_from_paths
        @files.collect do |f|
          f[:path].gsub!(%r(#{@base_path}#{File::SEPARATOR}), '')
        end
      end
  end
end