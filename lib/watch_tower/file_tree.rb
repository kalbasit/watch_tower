# -*- encoding: utf-8 -*-

module WatchTower
  # This class is used by the server to provided a FileTree representation
  # of the files and their elapsed time
  class FileTree

    attr_reader :base_path, :files, :nested_tree, :elapsed_time

    # Initialize
    #
    # @param [String] base_path: The base path of all files, usually the project's path
    # @param [Array] files: The files and their elapsed time
    #                The Array elements should be Hashes with two required keys
    #                :path and :elapsed_time
    def initialize(base_path, files)
      # Init with args
      @base_path = base_path
      @all_files = remove_base_path_from_files(@base_path, files)
      # Init with defaults
      @elapsed_time = 0
      @files = Array.new
      @nested_tree = Hash.new
      # Process the tree
      process
    end

    protected
      # Process the Tree
      def process
        # Parse files
        parse_files
        # Parse folders
        parse_folders
      end

      # Removes the base_path from the files
      def remove_base_path_from_files(base_path, files)
        files.collect do |f|
          f[:path] = f[:path].gsub(%r(#{base_path}#{File::SEPARATOR}), '')
          f
        end
      end

      # Parses only files under the current base_path
      def parse_files
        return if @files.any?

        @all_files.each do |f|
          unless f[:path] =~ %r(#{File::SEPARATOR})
            @elapsed_time += f[:elapsed_time]
            @files << f
          end
        end
      end

      # Parses only folders under the current base_path
      def parse_folders
        return if @nested_tree.any?

        @all_files.each do |f|
          if f[:path] =~ %r(#{File::SEPARATOR})
            # Get the base_path
            base_path = f[:path].split(File::SEPARATOR).first
            # Do not continue if we already parsed this path
            next if @nested_tree.has_key?(base_path)
            # Get the nested files
            nested_files = remove_base_path_from_files base_path,
              @all_files.select { |f| f[:path] =~ %r(^#{base_path}#{File::SEPARATOR}) }
            # Create a tree
            @nested_tree[base_path] = self.class.new("#{@base_path}#{File::SEPARATOR}#{base_path}", nested_files)
            # Add the elapsed_time of the tree
            @elapsed_time += @nested_tree[base_path].elapsed_time
          end
        end
      end
  end
end