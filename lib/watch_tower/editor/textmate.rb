module WatchTower
  module Editor
    class Textmate
      include BaseAppscript

      @@app = begin
        app 'Textmate'
      rescue
        nil
      end
    end
  end
end