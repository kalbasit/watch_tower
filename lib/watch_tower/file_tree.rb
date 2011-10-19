module WatchTower
  # This class is used by the server to provided a FileTree representation
  # of the files and their elapsed time
  class FileTree

    attr_reader :files

    # Initialize
    #
    # @param [String] base_path: The base path of all files, usually the project's path
    # @param [Array] files: The files and their elapsed time
    #                The Array elements should be Hashes with two required keys
    #                :path and :elapsed_time
    def initialize(base_path, files)
      @base_path = base_path
      @files = files
      @elapsed_time = 0
    end

    # Render the FileTree
    #
    # @return [Array] The FileTree representation
    def tree
      # Remove base_path from paths
      remove_base_path_from_paths
      # Parse files
      parse_files

      # Return a hash
      { files: files, elapsed_time: @elapsed_time }
    end

    protected
      # Removes the base_path from the files
      def remove_base_path_from_paths
        @files.collect do |f|
          f[:path].gsub!(%r(#{@base_path}#{File::SEPARATOR}), '')
        end
      end

      # Parses only files under the current base_path
      def parse_files
        # Iterate over each file to calculate the total elapsed time
        @files.each do |f|
          unless f[:path] =~ %r(#{File::SEPARATOR})
            @elapsed_time += f[:elapsed_time]
          end
        end
      end
  end
end