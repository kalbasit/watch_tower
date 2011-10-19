module WatchTower
  module Server
    module Presenters
      class ProjectPresenter < ApplicationPresenter

        # Return a file tree representation of a bunch of files
        #
        # @return [String] HTML representation of a file tree
        def file_tree(files)
          # Create a FileTree
          file_tree = FileTree.new(files.first.project.path, files)
          # Parse and return the tree
          parse_file_tree(file_tree, true)
        end
      end
    end
  end
end