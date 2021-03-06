# -*- encoding: utf-8 -*-

module WatchTower
  module Editor
    extend ::ActiveSupport::Autoload

    autoload :BaseAppscript
    autoload :BasePs
    autoload :Textmate
    autoload :Xcode
    autoload :Vim

    def self.editors
      Editor.constants.                                     # Collect the defined constants
        collect { |c| "::WatchTower::Editor::#{c}"}.        # Access them under the Server module
        collect(&:constantize).                             # Make them a constant
        select { |c| c.class == Class }                     # Keep only classes
    end
  end
end
